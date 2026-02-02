#!/bin/bash
set -e

REPO_URL="$1"
BRANCH="$2"
WORKDIR="/workspace/repo"

if [ ! -w /opt/build ]; then
  echo "❌ /opt/build is not writable."
  echo "👉 Fix with: mkdir -p output && chown 1000:1000 output"
  exit 1
fi

if [ -n "$REPO_URL" ]; then
  echo "📦 Repository URL provided"

  if [ -n "$BRANCH" ]; then
    echo "🌿 Cloning branch: $BRANCH"
    git clone --branch "$BRANCH" --single-branch "$REPO_URL" "$WORKDIR"
  else
    echo "🌿 Cloning default branch"
    git clone "$REPO_URL" "$WORKDIR"
  fi

elif [ -d "/workspace/.git" ]; then
  echo "📁 Using mounted git repository"
  WORKDIR="/workspace"
else
  echo "❌ No repository URL provided and /workspace is not a git repository"
  exit 1
fi

cd "$WORKDIR"

echo "🚀 Running krankerl package"
krankerl package

echo "✅ krankerl package completed successfully"

if [ -d "build" ]; then
  echo "📁 Copying build output to /opt/build"
  cp -r build/* /opt/build/
else
  echo "❌ build directory not found"
  exit 1
fi

echo "🎉 Build finished"
