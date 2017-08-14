CMAKE_COMPILER_OPTS=
CMAKE_TESTS_OPTS=-DENABLE_TESTS=on -DENABLE_FFTW=on \
		 -DENABLE_NAYUKI_PORTABLE=on -DENABLE_NAYUKI_AVX=on \
		 -DENABLE_SPQLIOS_AVX=on -DENABLE_SPQLIOS_FMA=on
CMAKE_DTESTS_OPTS=${CMAKE_COMPILER_OPTS} -DCMAKE_BUILD_TYPE=debug ${CMAKE_TESTS_OPTS}
CMAKE_OTESTS_OPTS=${CMAKE_COMPILER_OPTS} -DCMAKE_BUILD_TYPE=optim ${CMAKE_TESTS_OPTS}

all: build
	make -C build

install: build
	make -C build install

clean: build
	make -C build clean

distclean:
	rm -rf build builddtests buildotests; true

test: builddtests buildotests src/test/googletest/CMakeLists.txt
	make -j 4 -C builddtests
	make -j 4 -C buildotests
	make -j 4 -C builddtests test
	make -j 4 -C buildotests test

build: src/test/googletest/CMakeLists.txt
	mkdir build; cd build; cmake ../src; cd ..

builddtests:
	rm -rf $@; true; mkdir $@; 
	cd $@; cmake ../src ${CMAKE_DTESTS_OPTS}; 
	cd $@; cmake ../src ${CMAKE_DTESTS_OPTS};
	cd ..

buildotests:
	rm -rf $@; true; mkdir $@; 
	cd $@; cmake ../src ${CMAKE_OTESTS_OPTS}; 
	cd $@; cmake ../src ${CMAKE_OTESTS_OPTS};
	cd ..

src/test/googletest/CMakeLists.txt:
	git submodule init
	git submodule update
