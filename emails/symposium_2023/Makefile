FILE := save_the_date

TARGET = $(FILE).min.html

all: $(TARGET)

$(TARGET): $(FILE).html
	@echo "Minifying $(FILE).html"
	@yarn html-minifier --collapse-whitespace --remove-comments --remove-optional-tags --remove-redundant-attributes --remove-script-type-attributes --remove-tag-whitespace --use-short-doctype --minify-css true --minify-js true --output $(TARGET) $(FILE).html

$(FILE).html: $(FILE).mjml
	@echo "Compiling $(FILE).mjml"
	@yarn mjml $(FILE).mjml -o $(FILE).html

$(FILE).txt: $(FILE).html
	@echo "Converting $(FILE).html to $(FILE).txt"
	@cat $(FILE).html | yarn -s html-to-text > $(FILE).txt
