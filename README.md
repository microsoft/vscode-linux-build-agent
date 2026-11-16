# VS Code Linux Build Agent

[![Build Status](https://dev.azure.com/monacotools/Monaco/_apis/build/status%2FVS%20Code%20Linux%20Build%20Agent?branchName=main)](https://dev.azure.com/monacotools/Monaco/_build/latest?definitionId=509&branchName=main)

## Develop

Just push to `main`!

## Container images

Alpine build and sanity-test images use the official Alpine 3.22.8 image via `vscodehub.azurecr.io/cache/docker/library/alpine:3.22.8`. Deploy [acr-cache.bicep](acr-cache.bicep) with `dockerHubCredentialSetName` set to an existing Docker Hub credential set before building these images. The template creates the authenticated `linux-build-docker-alpine` cache rule.

Rebuild and validate both Alpine architectures before retiring the old `linux-build-mcr-devcontainers-base` cache rule and its unused manifests. Removing the rule from the template does not delete it during an incremental deployment, and deleting a cache rule does not delete already-cached images.

# Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
