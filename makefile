.PHONY: reproduce clear

clear:
	rm -r output
	mkdir output
	mkdir output/states

reproduce: clear
	cd notebooks && find . -type f -maxdepth 1 -print0 \
		| sort -z \
		| xargs -0  -I '{}' jupyter nbconvert \
		    --ExecutePreprocessor.timeout=-1 \
		    --ExecutePreprocessor.kernel_name=python3 \
		    --to notebook \
		    --output {} \
		    --execute {};
