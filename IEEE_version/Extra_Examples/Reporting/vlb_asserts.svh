/******************************************************************************
 ***                                                                        ***
 ***               Copyright 2014-2015 VerifLabs  a CVC venture             ***
 ***                                                                        ***
 ***                         http://www.cvcblr.com                          ***
 ***                         http://www.veriflabs.com                       ***
 ***                                                                        ***
 ***                                                                        ***
 ***                 Name         : VL_UVM_RAL                              ***
 ***                 Last Updated : 22/12/15                                ***
 ***                 Author       : VerifLabs Team                          ***
 ***                 Contact      : training@cvcblr.com                     ***
 ***                                                                        ***
 ***                                                                        ***
 ******************************************************************************
 ***                                                                        ***
 *** This is an unpublished, proprietary work of VerifLabs, a CVC venture   ***
 *** and is fully protected under copyright and trade secret laws. You may  ***
 *** not view, use, disclose, copy, or distribute this file or any          ***
 *** information contained herein except pursuant to a valid written        ***
 *** license from CVC/VerifLabs.                                            ***
 ***                                                                        ***
 ***       THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY              ***
 ***       EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED        ***
 ***       TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS        ***
 ***       FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR           ***
 ***       OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,              ***
 ***       INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES         ***
 ***       (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE        ***
 ***       GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR             ***
 ***       BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF       ***
 ***       LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT       ***
 ***       (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT       ***
 ***       OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE              ***
 ***       POSSIBILITY OF SUCH DAMAGE.                                      ***
 ***                                                                        ***
 *****************************************************************************/

import uvm_pkg::*;
`include "uvm_macros.svh"

default clocking @ (posedge clk);
endclocking

property p_rd_reset;
   (!rst_n |=> data_out == 8'd0);
endproperty : p_rd_reset

a_p_rd_reset : assert property (p_rd_reset)
  else
    `uvm_error("SVA", "data_out is not 0 after reset") 

property p_wr_rd_val;
   (wr_rd |-> wr_rd_valid);
endproperty : p_wr_rd_val

a_p_wr_rd_val : assert property (p_wr_rd_val)
  else
    `uvm_error("SVA", "Protocl violation! wr_rd is set HIGH without valid")

