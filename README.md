### Development of a multi-layer canopy model for E3SM Land Model with support for heterogeneous computing

This repository includes a script and dataset to reproduce the simulations
performed in the following manuscript:

Bisht, G., Riley, W. J., and Mills, R. T., Development of a multi-layer canopy 
model for E3SM Land Model with support for heterogeneous computing, sumitted to JAMES.


#### 1. Download the MPP code

The MPP code can be obtained from:

1. Zenodo: [https://zenodo.org/record/7809207#.ZDBxDuzMLS4](https://zenodo.org/record/7809207#.ZDBxDuzMLS4), or

2. Driectly from Github

```
git clone https://github.com/MPP-LSM/MPP MPP
cd MPP
git checkout v0.3.0
```


#### 2. Install the MPP code

Follow the `README.md` in the MPP code to first install PETSc and then
install the MPP.


#### 3. Use the `mlcm_run.sh` to run simulations

The control simulation (`-case_name control`) for the Medlyn stomatal conductance model (`-gs_type 0`)
can be run via

```
./mlcm_run.sh \
-gs_type 0 \
-case_name control \
-mpp_dir <path-to-mpp-dir>
```

