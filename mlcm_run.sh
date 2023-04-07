#!/bin/sh

gs_type=-1
case_name=
mppdir=/Users/bish218/projects/mlc-ngd-codes/mpp-base/
mppdir=

display_help() {
    echo "Usage: $0 " >&2
    echo
    echo "   -gs_type   <0-4>                                    Stomatal conductance model"
    echo "   -case_name <control,2K,5K,467ppm,567ppm,sm70,sm85>  Supported cases"
    echo "   -mpp_dir   <path-to-mpp-code>                       MPP code directory"
    echo "   -h, --help                                          Display this message"
    echo "   -v, --verbose                                       Set verbosity option true"
    echo
    exit 1
}

##################################################
# Get command line arguments
##################################################
while [ $# -gt 0 ]
do
  case "$1" in
    -gs_type )  gs_type="$2"; shift ;;
    -case_name) case_name="$2"; shift ;;
    -mpp_dir)  mppdir="$2"; shift ;;
    -*)
      display_help
      exit 0
      ;;
    -h | --help)
      display_help
      exit 0
      ;;
    *)  break;;  # terminate while loop
  esac
  shift
done

##################################################
# Check command line arguments
##################################################

if [ $gs_type -eq 0 ]
then
    export stomatal_conductance_model="medlyn";
    SNES_OPTIONS=" -pc_type lu -snes_linesearch_type bt"
elif [ $gs_type -eq 1 ]
then
    export stomatal_conductance_model="ball-berry";
    SNES_OPTIONS=" -pc_type lu -snes_linesearch_type bt"
elif [ $gs_type -eq 2 ]
then
    export stomatal_conductance_model="wue";
    SNES_OPTIONS=" -pc_type lu -snes_linesearch_type bt"
elif [ $gs_type -eq 3 ]
then
    export stomatal_conductance_model="bonan14";
    SNES_OPTIONS=" -snes_mf_operator -pc_type lu -snes_linesearch_type bt"
elif [ $gs_type -eq 4 ]
then
    export stomatal_conductance_model="manzoni11";
    SNES_OPTIONS=" -pc_type lu -snes_linesearch_type bt"
else
    echo "Unknown gs_type = $1"
    display_help
    exit 1
fi

if [ -z "$case_name" ]
then
    echo "The following command line option is not specified: -case_name <value> "
    display_help
fi

if [ -z "$mppdir" ]
then
    echo "The following command line option is not specified: -mpp_dir <value> "
    display_help
elif [ ! -f "$mppdir/local/bin/ml_model" ]
then
    echo "The MPP code directory found, but the following exectable is missing:"
    echo "   $mppdir/local/bin/ml_model"
    echo ""
    echo "Install MPP using instructions provided in the following file"
    echo "   $mppdir/README.md"
    exit 1
fi

echo "++++++++++++++++++++++++++++++"
echo "gs_type   = $gs_type"
echo "case_name = $case_name"
echo "Code dir  = $mppdir"
echo "++++++++++++++++++++++++++++++"

bc_dir=$PWD/bc/gs_type_${gs_type}/${case_name}
out_dir=$PWD/output/gs_type_${gs_type}/${case_name}

mkdir -p $out_dir
echo "pwd=$PWD"
echo "out_dir=$out_dir"

cd $mppdir

cmd="$mppdir/local/bin/ml_model \
-bc_file                    $bc_dir/bc.bin              \
-stomatal_conductance_model $stomatal_conductance_model \
-beg_step                   1                           \
-end_step                   744                         \
-checkpoint_data                                        \
-output_data                                            \
$SNES_OPTIONS "

cd local/bin

echo $cmd

echo $cmd > command_history.txt

matfile=mpp_output_gs_type_${gs_type}_${case_name}.m

$cmd 2>&1 | tee $matfile

mv *.bin* $out_dir
mv command_history.txt $out_dir
mv $matfile $out_dir
