OCAMLFIND = ocamlfind
OCAMLOPT = $(OCAMLFIND) ocamlopt
PKGS = yojson
TARGET = test
SRC_DIR = src
SOURCES = $(addprefix $(SRC_DIR)/, action.ml tape.ml machine.ml simulator.ml main.ml)
CMX_FILES = $(SOURCES:.ml=.cmx)

all: $(TARGET)

check-deps:
	opam install ocamlfind
	@for pkg in $(PKGS); do \
		$(OCAMLFIND) query $$pkg >/dev/null 2>&1 || (echo "Package '$$pkg' not found. Installing via opam..."; opam install $$pkg); \
	done

$(TARGET): check-deps $(CMX_FILES)
	eval $$(opam env) && $(OCAMLFIND) ocamlopt -linkpkg -package $(PKGS) -I $(SRC_DIR) $(CMX_FILES) -o $(TARGET)

%.cmx: %.ml
	eval $$(opam env) && $(OCAMLFIND) ocamlopt -package $(PKGS) -I $(SRC_DIR) -c $< 

clean:
	rm -f $(TARGET) $(SRC_DIR)/*.cmo $(SRC_DIR)/*.cmi $(SRC_DIR)/*.cmx $(SRC_DIR)/*.o

enter:
	docker-compose exec -it turing /bin/bash

.PHONY: all clean check-deps enter
