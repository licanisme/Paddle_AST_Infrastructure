#   Copyright (c) 2020 PaddlePaddle Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os
from api_upgrade_src.upgrade_models_api_utils import *


CONFIGURE_PATH = "./api_upgrade_src/dict/new_counter.dict"

class SysPaths:
    C_tmp = ""
    COUNTER_OUTPUT_PATH_ORI = '/work/debug/PaddleASTInfrastructure/paddle_api_upgrade/api_upgrade_src/dict/new_counter_output.dict'

class SysPaths_dynamic:
    def __init__(self):
        self.C_tmp_dynamic = ""
        COUNTER_OUTPUT_PATH_ORI = '/work/debug/PaddleASTInfrastructure/paddle_api_upgrade/api_upgrade_src/dict/new_counter_output.dict'

    def load_config(self, conf_file): 
        conf_dict = {"input_path": None, "output_path": None, "counter_path": None}
        print("hi")
        with open(conf_file, 'r') as fr: 
            for line in fr: 
                line = line.strip()
                if line.startswith("input_path"): 
                    conf_dict["input_path"] = line.split("=")[1].strip()
                if line.startswith("output_path"): 
                    conf_dict["output_path"] = line.split("=")[1].strip()
                if line.startswith("counter_path"): 
                    conf_dict["counter_path"] = line.split("=")[1].strip()
        return conf_dict


_config_dict = SysPaths_dynamic().load_config(CONFIGURE_PATH)
print("inside common module _config_dict: ", _config_dict)
print("inside common module C_tmp_dynamic: ", SysPaths_dynamic().C_tmp_dynamic)