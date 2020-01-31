/* This is a style that should NEVER BE USED 
 * However, there are many who code this way
 * including vendor supplied code generation templates 
 * and vendor supplied VIP.
 *
 * See the discussion in the book about this style.
 *
 * For the sake of completeness, I have included an example of how to do so.
 * If you are going to use this because your company guidelines say so, Comment out the 
 * set_automatic_phase_objection in the default sequence constructor before
 * using this sequence.
 */

class objection_in_sequence extends base_sequence;
   `uvm_object_utils(objection_in_sequence)
   `uvm_add_to_seq_lib(objection_in_sequence,wb_master_seqr_sequence_library)

   function new(string name="my_repeated_read_sequence");
      super.new(name);
   endfunction

   virtual task body();
      // Raise the objection, we are starting the sequence
      uvm_phase phase_ = get_starting_phase();
      if (phase_ != null)
        phase_.raise_objection(this);
      
      `uvm_do(req, get_sequencer(), -1, {address == 0; kind == wb_transaction::READ; })
      `uvm_do(req, get_sequencer(), -1, {address == 1; kind == wb_transaction::READ; })
      `uvm_do(req, get_sequencer(), -1, {address == 2; kind == wb_transaction::READ; })
      `uvm_do(req, get_sequencer(), -1, {address == 3; kind == wb_transaction::READ; })

      // Drop the objection, we got done with the sequence
      if (phase_ != null)
	phase_.drop_objection(this);
   endtask

endclass

