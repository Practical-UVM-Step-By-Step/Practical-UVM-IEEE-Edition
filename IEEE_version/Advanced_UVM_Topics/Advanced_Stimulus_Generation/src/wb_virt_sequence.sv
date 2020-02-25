typedef class sequence_0;
   typedef class sequence_1;
   typedef class sequence_2;

class wb_virtual_seq extends uvm_sequence ;

   `uvm_object_utils(wb_virtual_seq);
   `uvm_declare_p_sequencer(wb_virt_sequencer)
   sequence_0 sequence0;
   sequence_1 sequence1;
   sequence_2 sequence2;

   virtual task body();
      uvm_phase phase_=get_starting_phase();

      phase_.raise_objection(this);
      `uvm_info("VIRT_SEQQ","Starting Virtual Sequence:",UVM_LOW)
      sequence0 = sequence_0::type_id::create("Sequence0");
      sequence1 = sequence_1::type_id::create("Sequence1");
      sequence2 = sequence_2::type_id::create("Sequence2");

      fork
         begin
            sequence0.start(p_sequencer.seqr1,this,20,0);
            sequence2.start(p_sequencer.seqr1,this,50,0);
            sequence1.start(p_sequencer.seqr1,this,1000,0);
         end
      join
      phase_.drop_objection(this);
   endtask

   function new(string name="vir_sequence");
      super.new(name);
   endfunction
endclass

