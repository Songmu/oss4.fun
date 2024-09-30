#!/bin/sh -l

# copied from following and modified
# https://github.com/cpina/github-action-push-to-another-repository/blob/7c1bd869f38327ce403753fc2a5769e26cacb5ac/entrypoint.sh

set -e  # if a command fails it stops the execution

echo "[+] Action start"
GITHUB_SERVER="github.com"
SOURCE_DIRECTORY="."
DESTINATION_GITHUB_USERNAME="Songmu"
DESTINATION_REPOSITORY_NAME="oss4.fun"
USER_EMAIL="y.songmu@gmail.com"
USER_NAME="Masayuki Matsuki"
DESTINATION_REPOSITORY_USERNAME="Songmu"
TARGET_BRANCH="main"
TARGET_DIRECTORY=""
COMMIT_MESSAGE="$(git log -1 --pretty=%B)"

if [ -z "$COMMIT_MESSAGE" ]; then
  $COMMIT_MESSAGE="Update from private repository"
fi

if [ -z "$DESTINATION_REPOSITORY_USERNAME" ]; then
  DESTINATION_REPOSITORY_USERNAME="$DESTINATION_GITHUB_USERNAME"
fi

if [ -z "$USER_NAME" ]; then
	USER_NAME="$DESTINATION_GITHUB_USERNAME"
fi

echo "[+] Using API_TOKEN_GITHUB"
GIT_CMD_REPOSITORY="https://$DESTINATION_REPOSITORY_USERNAME:$API_TOKEN_GITHUB@$GITHUB_SERVER/$DESTINATION_REPOSITORY_USERNAME/$DESTINATION_REPOSITORY_NAME.git"


CLONE_DIR=$(mktemp -d)

echo "[+] Git version"
git --version

echo "[+] Enable git lfs"
git lfs install

echo "[+] Cloning destination git repository $DESTINATION_REPOSITORY_NAME"

# Setup git
git config --global user.email "$USER_EMAIL"
git config --global user.name "$USER_NAME"

# workaround for https://github.com/cpina/github-action-push-to-another-repository/issues/103
git config --global http.version HTTP/1.1

{
	git clone --single-branch --depth 1 --branch "$TARGET_BRANCH" "$GIT_CMD_REPOSITORY" "$CLONE_DIR"
} || {
	echo "::error::Could not clone the destination repository. Command:"
	echo "::error::git clone --single-branch --branch $TARGET_BRANCH $GIT_CMD_REPOSITORY $CLONE_DIR"
	echo "::error::(Note that if they exist USER_NAME and API_TOKEN is redacted by GitHub)"
	echo "::error::Please verify that the target repository exist AND that it contains the destination branch name, and is accesible by the API_TOKEN_GITHUB OR SSH_DEPLOY_KEY"
	exit 1

}
ls -la "$CLONE_DIR"

TEMP_DIR=$(mktemp -d)
# This mv has been the easier way to be able to remove files that were there
# but not anymore. Otherwise we had to remove the files from "$CLONE_DIR",
# including "." and with the exception of ".git/"
mv "$CLONE_DIR/.git" "$TEMP_DIR/.git"

# $TARGET_DIRECTORY is '' by default
ABSOLUTE_TARGET_DIRECTORY="$CLONE_DIR/$TARGET_DIRECTORY/"

echo "[+] Deleting $ABSOLUTE_TARGET_DIRECTORY"
rm -rf "$ABSOLUTE_TARGET_DIRECTORY"

echo "[+] Creating (now empty) $ABSOLUTE_TARGET_DIRECTORY"
mkdir -p "$ABSOLUTE_TARGET_DIRECTORY"

echo "[+] Listing Current Directory Location"
ls -al

mv "$TEMP_DIR/.git" "$CLONE_DIR/.git"

echo "[+] List contents of $SOURCE_DIRECTORY"
ls -al "$SOURCE_DIRECTORY"

echo "[+] Checking if local $SOURCE_DIRECTORY exist"
if [ ! -d "$SOURCE_DIRECTORY" ]
then
	echo "ERROR: $SOURCE_DIRECTORY does not exist"
	echo "This directory needs to exist when push-to-another-repository is executed"
	echo
	echo "In the example it is created by ./build.sh: https://github.com/cpina/push-to-another-repository-example/blob/main/.github/workflows/ci.yml#L19"
	echo
	echo "If you want to copy a directory that exist in the source repository"
	echo "to the target repository: you need to clone the source repository"
	echo "in a previous step in the same build section. For example using"
	echo "actions/checkout@v2. See: https://github.com/cpina/push-to-another-repository-example/blob/main/.github/workflows/ci.yml#L16"
	exit 1
fi

echo "[+] rm source .git directory to avoid conflicts"
rm -rf "$SOURCE_DIRECTORY/.git"

echo "[+] Copying contents of source repository folder $SOURCE_DIRECTORY to folder $TARGET_DIRECTORY in git repo $DESTINATION_REPOSITORY_NAME"
cp -ra "$SOURCE_DIRECTORY"/. "$CLONE_DIR/$TARGET_DIRECTORY"
cd "$CLONE_DIR"

echo "[+] Files that will be pushed"
ls -la

echo "[+] Set directory is safe ($CLONE_DIR)"
# Related to https://github.com/cpina/github-action-push-to-another-repository/issues/64
git config --global --add safe.directory "$CLONE_DIR"

# echo "[+] git config --unset-all"
# git config --unset-all http.https://github.com/.extraheader

echo "[+] Adding git commit"
git add .

echo "[+] git status:"
git status

echo "[+] git diff-index:"
# git diff-index : to avoid doing the git commit failing if there are no changes to be commit
git diff-index --quiet HEAD || git commit --message "$COMMIT_MESSAGE"

echo "[+] Pushing git commit"
# --set-upstream: sets de branch when pushing to a branch that does not exist
git push "$GIT_CMD_REPOSITORY" --set-upstream "$TARGET_BRANCH"
