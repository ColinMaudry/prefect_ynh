#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================
myynh_setup_python_venv() {
    # Always recreate everything fresh with current python version
    rm -rf "$data_dir/venv"

    # Skip pip because of: https://github.com/YunoHost/issues/issues/1960
    python3 -m venv --without-pip "$data_dir/venv"

    chown -c -R "$app:" "$data_dir"

    # run source in a 'sub shell'
    (
        set +o nounset
        source "$data_dir/venv/bin/activate"
        set -o nounset
        set -x
        ynh_exec_as_app $app $data_dir/venv/bin/python3 -m ensurepip
        ynh_exec_as_app $app $data_dir/venv/bin/pip3 install --upgrade wheel pip setuptools
        ynh_exec_as_app $app $data_dir/venv/bin/pip3 install -r "$data_dir/requirements.txt"
    )
}