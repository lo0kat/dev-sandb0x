
Generate ignition files with the butane image : 
```sh
$ docker run -i --rm quay.io/coreos/butane:release --pretty --strict < installer.bu > installer.ign

$ docker run -i --rm quay.io/coreos/butane:release --pretty --strict < template.bu > template.ign
```