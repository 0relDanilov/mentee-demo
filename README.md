# mentee-demo

A small Python app with a CI/CD pipeline on AWS. You push to `main`, and it gets built, versioned, put in a container, and deployed on its own. All the AWS setup is in Terraform.

## How it works

GitHub → CodePipeline → CodeBuild → ECR → ECS Fargate.

Push to `main` kicks off the pipeline. CodeBuild builds the Docker image and pushes it to ECR. ECS Fargate runs it as a service on a public IP (port 8080). Everything runs in `eu-north-1`.

## Versioning

The version lives in `version.txt` (e.g. `1.0.7`). You bump it by hand: patch for fixes, minor for features, major for breaking changes.

The pipeline reads that file, bakes the version into the image, and tags the image in ECR three ways: `1.0.7`, `1.0.7-<commit>`, and `latest`. The app reads its version at runtime, so what's running always matches what was built.

## Files
hello_world.py   # the app

Dockerfile       # the image

version.txt      # the version

buildspec.yml    # build steps

terraform/       # all the AWS stuff

## Run it

```bash
cd terraform
terraform init
terraform apply
```

After the first apply you authorize the GitHub connection once in the AWS console (it installs the GitHub app). After that, every push to `main` deploys on its own.
