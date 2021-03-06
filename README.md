# Drone plugin for ChartMuseum

[![Docker Repository on Quay](https://quay.io/repository/honestbee/drone-chartmuseum/status "Docker Repository on Quay")](https://quay.io/repository/honestbee/drone-chartmuseum)
[![Maintainability](https://api.codeclimate.com/v1/badges/3667089f0bcc8c0f8735/maintainability)](https://codeclimate.com/github/honestbee/drone-chartmuseum/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/3667089f0bcc8c0f8735/test_coverage)](https://codeclimate.com/github/honestbee/drone-chartmuseum/test_coverage)

Drone plugin to package and upload Helm charts to [ChartMuseum](https://github.com/kubernetes-helm/chartmuseum)

When managing Charts for your organisation, you may either choose to put Chart definitions within each project or centralised in a `helm-charts` repository. The official public-charts repo is an example of the latter.

This plugin supports both approaches as well as the ability to detect and process only changes as part of a git repository.

## Usage Examples

- Process all charts from root of repository

  Package all charts under `chart_dir` and upload to Repository server.

  ```YAML
  pipeline:
    chartmuseum-all:
      image: quay.io/honestbee/drone-chartmuseum
      repo_url: http://helm-charts.example.com
      when:
        branch: [master]
  ```

- Process only changed charts

  Detect changed files between `previous_commit` and `current_commit`, only package and upload modified helm charts. Ignores modifications if they match `.helmignore` rules.

  ```YAML
  pipeline:
    chartmuseum-diff:
      image: quay.io/honestbee/drone-chartmuseum
      repo_url: http://helm-charts.example.com
      previous_commit: ${DRONE_PREV_COMMIT_SHA}
      current_commit: ${DRONE_COMMIT_SHA}
      when:
        branch: [master]
  ```

- Process only a specific chart. Can be combined with commit SHA to only process if chart is modified. (also uses `.helmignore`)

  ```YAML
  pipeline:
    chartmuseum-single:
      image: quay.io/honestbee/drone-chartmuseum
      repo_url: http://helm-charts.example.com
      chart_path: nginx
      when:
        branch: [master]
  ```

## Full utilisation details

```bash
NAME:
   drone-chartmuseum-plugin - drone plugin to upload charts to chartmuseum server

USAGE:
   drone-chartmuseum [global options] command [command options] [arguments...]

VERSION:
   1.0.0

COMMANDS:
     help, h  Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --repo-url value, -u value                   ChartMuseum API base URL [$PLUGIN_REPO_URL, $REPO_URL]
   --chart-path value, -i value                 Path to chart, relative to charts-dir [$PLUGIN_CHART_PATH, $CHART_PATH]
   --charts-dir value, -d value                 chart directory (default: "./") [$PLUGIN_CHARTS_DIR, $CHARTS_DIR]
   --save-dir value, -o value                   Directory to save chart packages (default: "uploads/") [$PLUGIN_SAVE_DIR, $SAVE_DIR]
   --previous-commit COMMIT_SHA, -p COMMIT_SHA  Previous commit id (COMMIT_SHA) [$PLUGIN_PREVIOUS_COMMIT, $PREVIOUS_COMMIT]
   --current-commit COMMIT_SHA, -c COMMIT_SHA   Current commit id (COMMIT_SHA) [$PLUGIN_CURRENT_COMMIT, $CURRENT_COMMIT]
   --log-level value                            Log level (panic, fatal, error, warn, info, or debug) (default: "error") [$PLUGIN_LOG_LEVEL, $LOG_LEVEL]
   --help, -h                                   show help
   --version, -v                                print the version
```

```bash
docker run --rm \
  -e PLUGIN_REPO_URL="http://helm-charts.example.com" \
  -e PLUGIN_PREVIOUS_COMMIT="<commit-sha>" \
  -e PLUGIN_CURRENT_COMMIT="<commit-sha>" \
  quay.io/honestbee/drone-chartmuseum
```

## Unit Tests

Unit tests support log level also, though you may need to clean cache when changing log level.

```bash
go clean -cache
LOG_LEVEL=debug go test -v ./...
```

## To Do

- Support http basic authentication
- Support chart dependencies
