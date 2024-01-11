CLASS zcl_flight_starter_contr DEFINITION
  PUBLIC
INHERITING FROM cl_demo_classrun
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS main REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_flight_starter_contr IMPLEMENTATION.


  METHOD main.
    DATA lo_operation TYPE REF TO if_bgmc_op_single.
    DATA lo_process TYPE REF TO if_bgmc_process_single_op.
    DATA lo_process_monitor TYPE REF TO if_bgmc_process_monitor.
*    lo_operation = NEW zcl_flight_operation_contr( i_flight_keys = VALUE #( carrier_id = 'AA'
*                                                                              connection_id = '15'
*                                                                              flight_date = '20240802' ) ).
     lo_operation = new zcl_demo_bgpf_operation_contr( 'Input data' ).
    TRY.
        lo_process = cl_bgmc_process_factory=>get_default( )->create( ).
        lo_process->set_name( 'Test process 1'
                 )->set_operation( lo_operation ).
        lo_process_monitor = lo_process->save_for_execution( ).
        COMMIT WORK.
*        data(state) = lo_process_monitor->get_state( ).
*        out->write( state ).

      CATCH cx_bgmc INTO DATA(lx_bgmc).
        out->write( lx_bgmc->get_longtext(  ) ).
        ROLLBACK WORK.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
