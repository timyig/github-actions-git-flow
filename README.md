# github-actions-git-flow
Template for Github Actions for git-flow branching strategy

## About git-flow
https://nvie.com/posts/a-successful-git-branching-model/

## Github Actions Workflow

### Branches

### Workflows

* main
  * When PR is opened pull images and run sanity checks
  * Tag the images with the `Tag` and push
* dev
  * When PR is opend build, test and push image
    * Tag with dev and datetime (YYYY-MM-DD-HH-MM)
  * When commit is tagged open PR into main
* feat
  * Feature branches
  
### ToDos

* [ ] Build, Test, Push on PR to `dev`
  * [ ] Get tag the image
* [ ] Trigger PR into main when commit is tagged in `dev`
* [ ] On PR opened in main, pull, tag and push image