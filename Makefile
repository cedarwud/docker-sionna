GPU=
ifdef gpus
    GPU=--gpus=$(gpus)
endif
export GPU

doc: FORCE
	cd doc && ./build_docs.sh

docker:
	docker build -t sionna_102 -f DOCKERFILE .

# Installs RT first (needed for the metapackage dependency) then Sionna itself
install: FORCE
	pip install ext/sionna-rt/
	pip install .

# New location of the python sources is src/sionna/
lint:
	pylint src/sionna/

notebook:
	export SIONNA_NO_PREVIEW=1; \
	jupyter nbconvert --to notebook --execute --inplace $(file)

run-docker:
	docker run -p 8888:8888 --privileged=true $(GPU) \
	           --env NVIDIA_DRIVER_CAPABILITIES=graphics,compute,utility \
	           --rm -it sionna_102

test: FORCE
	cd test && pytest

FORCE:

