#!/bin/bash
# Test script for this worklfow:
# .github/workflows/release.yml
# when running this localy by triggering the workflow run this command:
# act -W .github/workflows/act.yml --actor $GITHUB_USER --secret GITHUB_TOKEN=${GITHUB_TOKEN}
# act push --workflows .github/workflows/release.yml --secret GITHUB_TOKEN=${GITHUB_TOKEN} --actor $GITHUB_USER --eventpath .github/workflows/act/event-release.json

# Sanity check
echo "🧪🧪🧪 Sanity Check 🧪🧪🧪"
set -e
if [ -z $GITHUB_TOKEN ] ; then
  echo "GITHUB_TOKEN not set"
  exit 1
fi

if [ -z $GITHUB_USER ] ; then
  echo "GITHUB_USER not set"
  exit 1
fi

# Not running this in ACT
if [ -z "$ACT" ]; then
  echo "Not running in act"
else
  echo "⚠️ Skipping steps when running in act"
fi

echo "🧪🧪🧪 Testing act --list 🧪🧪🧪"
act --list
act push --list
act push --list --eventpath .github/workflows/act/event-release.json

echo "🧪🧪🧪 Testing act --dryrun 🧪🧪🧪"
export RESULT=$(act --workflows .github/workflows/release.yml --dryrun 2>&1 )
# This test should not return an error
if [[ ${RESULT,,} == *"failure"* || ${RESULT,,} == *"error"* ]]; then
  echo "❌ Release workflow: The run failed"
  echo -e "Result of run: \n ${RESULT}"
  exit 1
else
  echo "✅ Release workflow dryrun"
fi

echo "🧪🧪🧪 Testing  triggers 🧪🧪🧪"
echo "❓ Check if version is set"
# export RESULT=$(act push \
# --workflows .github/workflows/release.yml \
# --secret GITHUB_TOKEN=${GITHUB_TOKEN} \
# --actor $GITHUB_USER \
# --eventpath .github/workflows/act/event-release.json 2>&1)

act pull_request \
--workflows .github/workflows/release.yml \
--secret GITHUB_TOKEN=${GITHUB_TOKEN} \
--actor $GITHUB_USER \
--eventpath .github/workflows/act/event-dev-pr-release.json

# This test should not return an error
# if [[ ${RESULT,,} == *"failure"* || ${RESULT,,} == *"error"* ]]; then
#   echo "❌ Release workflow: The run failed"
#   echo -e "Result of run: \n ${RESULT}"
#   exit 1
# else
#   echo "✅ Release workflow"
#   echo "$RESULT" | grep -o "Release version: [^ ]*"
# fi
