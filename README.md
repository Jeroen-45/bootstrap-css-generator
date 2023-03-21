# Bootstrap CSS Generator
A script to easily generate modified versions of bootstrap using just a simple scss file containing your changes as the input.

## Installation
Simply clone or download this repo. Further dependencies are:

- npm and the packages sass, postcss, postcss-cli, autoprefixer and clean-css-cli  
  ```
  npm install sass postcss postcss-cli autoprefixer clean-css-cli
  ```
- curl
- wget
- unzip

Alternatively, you can use the docker script to avoid having to install NPM and these packages on your system. 
In that case the only dependency is docker itself.

## Usage
Create your .scss file to change/override the default bootstrap values. An example file has been provided. 
In this file, the color of Bootstrap purple is changed, and the primary color is set to this purple color instead of the default blue.
Once you have your .scss file, you can run either of the following commands, depending on whether you want to use docker 
or have installed the packages on your system yourself. For more information on how to change things using this file, you can consult
the [Bootstrap documentation](https://getbootstrap.com/docs/5.3/customize/sass/) on this.

**Regular command (npm and packages installed on your system)**
```
./create_css.sh your-file.scss
```

**Docker command**
```
./create_css_docker.sh your-file.scss
```

By default, the most recent release (so not the "latest" release) of Bootstrap is automatically downloaded and used to generate the css. 
If you want to use a different version, you can download its source code from the [Bootstrap releases](https://github.com/twbs/bootstrap/releases)
and put it in a folder called `bootstrap` within the same folder as the scripts.

After running the command, three files are created:
- `your-file.css`: The raw CSS output from Sass,
- `your-file-prefixed.css`: CSS that has been processed by autoprefixer, which is used to add vendor prefixes to the CSS,
- `your-file-prefixed.min.css`: A minified version of the previous file. This is the end result you'll want to use for your website.
