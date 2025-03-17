# Jammy base run image with fonts support

This is DTForce's take on creating a base OCI run image for containerized (cloud) deployments of Java applications with support for Jasper Reports and and some commonly used fonts. This derrives from tha fact, that `base` OCI images, although beautifuly lean and otherwise fantastic in almost every other aspect, lack some type-related libraries and fonts.

The basic idea comes from [this stack overflow question](https://stackoverflow.com/questions/3811908/font-is-not-available-to-the-jvm-with-jasper-reports), as Jasper-based reporting in many opensource tools that we are using (including Jmix) are throwing the infamous `RuntimeException: Fontconfig head is null, check your fonts or fonts configuration at java.desktop/sun.awt.FontConfiguration.getVersion()` exception on some reporting/export functions when run on `base` OCI images (not the bloated `full` images). 

On top of that, we are adding the `MS core TTF fonts` as they introduce typefaces commonly used in these reports (like `Arial`) and add support for accented characters commonly used in many European languages (including the CEE ones).

Based on latest [paketobuildpacks/run-jammy-base image](https://hub.docker.com/r/paketobuildpacks/run-jammy-base) with

- libfreetype6
- fontconfig
- ttf-mscorefonts-installer

## Legal

Deliberations and conclusions that you should be legally able to distribute (and embed) MS core TTF fonts are here:

- https://law.stackexchange.com/questions/84185/am-i-allowed-to-use-microsofts-truetype-core-fonts-outside-my-computer
- https://learn.microsoft.com/en-us/typography/fonts/font-faq

## Basic usage

Just use the `dtforce/run-jammy-base-ttfonts:latest` as the `runImage` of your `bootBuildImage` Gradle task.

## Advanced usage

If you want to build your own runimage (feel free to fork) or suggest a useful change to this repo (we weill accept sensible pull requests that contribute to general usability of the image and do not bloat it unnecessarily).

1. Touch the `Dockerfile` and make your adjustments as required
2. Build the image `docker build . -t dtforce/run-jammy-base-ttfonts:0.1.143 -t dtforce/run-jammy-base-ttfonts:latest` (or your tag)
3. Push the image `docker push dtforce/run-jammy-base-ttfonts:0.1.143 && docker push dtforce/run-jammy-base-ttfonts:latest` (or your tag)
4. Use the image as `runImage` of the `bootBuildImage` Gradle task in your project (see the Basic usage above)

## Closing remarks and troubleshooting

This works in a way that /opt (workspace) where your app would be normally residing is not writable to the app and if you need to 
have a working/temp dir you need to direct your app to use /home/cnb/

For instance for the popular Jmix framework that we're often using, this would mean setting something like this for 
production deployment 

```properties
jmix.core.temp-dir = /home/cnb/.jmix/temp
jmix.core.work-dir = /home/cnb/.jmix/work
```
