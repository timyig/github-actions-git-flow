#!/bin/bash
# Test script for this worklfow:
# .github/workflows/dev-pr.yml
# when running this localy by triggering the workflow run this command:
# act -W .github/workflows/act.yml --actor $GITHUB_USER --secret GITHUB_TOKEN=${GITHUB_TOKEN}

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
act pull_request --list

echo "🧪🧪🧪 Testing act --dryrun 🧪🧪🧪"
act --workflows .github/workflows/dev-pr.yml --dryrun
act --workflows .github/workflows/dev-pr.yml --dryrun --eventpath .github/workflows/act/event-dev-pr.json

# Testing triggers
echo "🧪🧪🧪 Testing Triggers 🧪🧪🧪"
echo "❓ Check if workflow is skipped"
RESULT=$(act push --workflows .github/workflows/dev-pr.yml --actor $GITHUB_USER --secret GITHUB_TOKEN=$GITHUB_TOKEN 2>&1)
# Result should be empty
if [ -z "$RESULT"]; then
  echo "✅ dev-pr workflow skipped for push"
else
  echo "❌ dev-pr workflow: Error on push event"
  echo -e "Result of run: \n ${RESULT}"
  exit 1
fi

echo "❓ Check if pull_request workflow"
RESULT=$(act pull_request --workflows .github/workflows/dev-pr.yml --actor $GITHUB_USER --secret GITHUB_TOKEN=${GITHUB_TOKEN} 2>&1)
# This test should not return an error
if [[ ${RESULT,,} == *"error"* ]]; then
  echo "❌ dev-pr workflow: pull_request"
  echo -e "Result of run: \n ${RESULT}"
  exit 1
else
  echo "✅ dev-pr workflow: pull_request"
fi
