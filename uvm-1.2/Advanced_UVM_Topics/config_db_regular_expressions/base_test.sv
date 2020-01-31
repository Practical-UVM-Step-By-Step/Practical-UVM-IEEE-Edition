//----------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2010 Cadence Design Systems, Inc.
//   Copyright 2010-2011 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------


//Begindoc: Automated Configuration
//This test will focus on testing auto configurations using the uvm_component related config methods.
//
//
//
//To get a more details about the auto config methods of the uvm component, refer to the file:
//	- uvm/src/base/uvm_component.svh , the configuration related part.
//
//
//
//Walk through the test:
//Configuration settings are stored in each component instance. 
//
//Then a search is made to verify that those components full names match the field_name that had been set.
// 
//
//The following configuration interfaces virtual methods will be override:
//
//void uvm_config_db #(int)::set (string inst_name,string field_name,uvm_bitstream_t value)
//
//void set_config_object (string inst_name,string field_name,uvm_object value, bit clone=1)
//
//void uvm_config_db #(string)::set (string inst_name,string field_name,string value)
//


module top;
   import uvm_pkg::*;
   import my_env_pkg::*;

   my_env topenv;


   logic unsigned [4095:0] my_int;
   string 		   my_string;

   initial begin
      //set configuration prior to creating the environment
      uvm_config_db #(int)::set("topenv.inst1.u1", "v", 30);
      uvm_config_db #(int)::set("topenv.instB.u1", "v", 10);
      uvm_config_db #(int)::set("*", "recording_detail", 0);
      uvm_config_db #(string)::set("*", "myaa[foo]", "hi");
      uvm_config_db #(string)::set("*", "myaa[bar]", "bye");
      uvm_config_db #(string)::set("*", "myaa[foobar]", "howdy");
      uvm_config_db #(string)::set("topenv.inst1.u1", "myaa[foo]", "foo");
      uvm_config_db #(string)::set("topenv.inst1.u1", "myaa[foobar]", "foobah");

      // Set the value of V to 30 for tom05 to tom07
      // uvm_config_db #(int)::set("/topenv\.tom0[5-7*]\.u1/", "v", 30);

      // This one should not match tommm10.u1
      //     uvm_config_db #(int)::set("/topenv\.tommmm1[1-4*]\.u1/", "v", 10); 


      // uvm_config_db #(int)::set("/topenv\.tom{4}*\.u1/", "v", 22);
      //uvm_config_db #(int)::set("/topenv\.tommmm1[1-4*]\.u1/", "v", 10); // uvm_config_db #(int)::set("/topenv\.tom{4}*\.u1/", "v", 22);
      // uvm_config_db #(int)::set("/topenv\.TOMMmm[15-19]*\.u1/", "v", 30); // uvm_config_db #(int)::set("/topenv\.tom{4}*\.u1/", "v", 22);

      // uvm_config_db #(int)::set("/topenv\.TOMMMM.*\.u1/", "v", 10); // uvm_config_db #(int)::set("/topenv\.tom{4}*\.u1/", "v", 22);
      //uvm_config_db #(int)::set("/topenv\.TOM\{4\}.[15-18*]\.u1/", "v", 10); // uvm_config_db #(int)::set("/topenv\.tom{4}*\.u1/", "v", 22);
      // uvm_config_db #(int)::set("/topenv\.TOM\{4\}.1[1-5.]\.u1/", "v", 10); // uvm_config_db #(int)::set("/topenv\.tom{4}*\.u1/", "v", 22);

      //uvm_config_db #(int)::set("/topenv\.TOM\{1,4\}.0[^0-2.]\.u1/", "v", 10); // uvm_config_db #(int)::set("/topenv\.tom{4}*\.u1/", "v", 22);
      //uvm_config_db #(int)::set("/topenv\.tom0[^0-2.]\.u1/", "v", 8); // uvm_config_db #(int)::set("/topenv\.tom{4}*\.u1/", "v", 22);
      //uvm_config_db #(int)::set("/topenv\.tom+[0-1.][^0-2.]\.u1/", "v", 8); // uvm_config_db #(int)::set("/topenv\.tom{4}*\.u1/", "v", 22);

      // need to try alternation
      topenv = new("topenv", null);



      run_test();


   end

endmodule
