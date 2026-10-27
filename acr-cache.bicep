targetScope = 'resourceGroup'

@description('Name of an existing Docker Hub credential set on vscodehub, configured for the docker.io login server.')
@minLength(5)
@maxLength(50)
param dockerHubCredentialSetName string

resource registry 'Microsoft.ContainerRegistry/registries@2025-04-01' existing = {
  name: 'vscodehub'
}

resource dockerHubCredentialSet 'Microsoft.ContainerRegistry/registries/credentialSets@2025-04-01' existing = {
  parent: registry
  name: dockerHubCredentialSetName
}

var publicSources = [
  {
    name: 'mcr-devcontainers-base'
    sourceRepository: 'mcr.microsoft.com/devcontainers/base'
    targetRepository: 'cache/mcr/devcontainers/base'
  }
  {
    name: 'mcr-debian'
    sourceRepository: 'mcr.microsoft.com/mirror/docker/library/debian'
    targetRepository: 'cache/mcr/mirror/docker/library/debian'
  }
  {
    name: 'mcr-ubuntu'
    sourceRepository: 'mcr.microsoft.com/mirror/docker/library/ubuntu'
    targetRepository: 'cache/mcr/mirror/docker/library/ubuntu'
  }
  {
    name: 'mcr-qemu-user-static'
    sourceRepository: 'mcr.microsoft.com/mirror/docker/multiarch/qemu-user-static'
    targetRepository: 'cache/mcr/mirror/docker/multiarch/qemu-user-static'
  }
  {
    name: 'quay-centos'
    sourceRepository: 'quay.io/centos/centos'
    targetRepository: 'cache/quay/centos/centos'
  }
]

var dockerHubSources = [
  {
    name: 'docker-fedora'
    sourceRepository: 'docker.io/library/fedora'
    targetRepository: 'cache/docker/library/fedora'
  }
  {
    name: 'docker-opensuse'
    sourceRepository: 'docker.io/opensuse/leap'
    targetRepository: 'cache/docker/opensuse/leap'
  }
  {
    name: 'docker-redhat'
    sourceRepository: 'docker.io/redhat/ubi9'
    targetRepository: 'cache/docker/redhat/ubi9'
  }
]

resource publicCacheRules 'Microsoft.ContainerRegistry/registries/cacheRules@2025-04-01' = [for image in publicSources: {
  parent: registry
  name: 'linux-build-${image.name}'
  properties: {
    sourceRepository: image.sourceRepository
    targetRepository: image.targetRepository
  }
}]

resource dockerHubCacheRules 'Microsoft.ContainerRegistry/registries/cacheRules@2025-04-01' = [for image in dockerHubSources: {
  parent: registry
  name: 'linux-build-${image.name}'
  properties: {
    credentialSetResourceId: dockerHubCredentialSet.id
    sourceRepository: image.sourceRepository
    targetRepository: image.targetRepository
  }
}]

@description('Upstream repositories and their cached pull paths. Append the original tag or digest when pulling.')
output cachedRepositories array = [for image in concat(publicSources, dockerHubSources): {
  sourceRepository: image.sourceRepository
  cachedRepository: '${registry.properties.loginServer}/${image.targetRepository}'
}]
