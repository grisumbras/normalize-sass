workflow "Publish" {
  on = "push"
  resolves = "publish"
}

action "publish" {
  needs = ["filter-publish", "store-env"]
  uses = "grisumbras/conan-actions/cpt@0.1.0"
  secrets = ["CONAN_LOGIN_USERNAME", "CONAN_PASSWORD"]
}


workflow "Build" {
  on = "push"
  resolves = "build"
}

action "build" {
  needs = ["filter-not-publish", "store-env"]
  uses = "grisumbras/conan-actions/cpt@0.1.0"
}


action "filter-publish" {
  uses = "actions/bin/filter@master"
  args = "branch master || tag"
}


action "filter-not-publish" {
  uses = "actions/bin/filter@master"
  args = "not branch master && not tag"
}


action "store-env" {
  uses = "grisumbras/store-env@master"
  env = {
    CONAN_CHANNEL = "testing"
    CONAN_STABLE_BRANCH_PATTERN = "\\d+\\.\\d+(\\.\\d+[-\\w\\.]*)?"
    CONAN_PRINT_RUN_COMMANDS = "1"
    CONAN_UPLOAD = "https://api.bintray.com/conan/grisumbras/conan"
    CONAN_USERNAME = "grisumbras"
  }
}
