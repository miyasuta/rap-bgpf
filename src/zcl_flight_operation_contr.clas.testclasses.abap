class ltcl_ definition final for testing
  duration short
  risk level harmless.

  private section.
    class-data go_bgpf_test_env type ref to if_bgmc_test_envir_spy.
    METHODS execute for testing raising cx_static_check.
    METHODS teardown.

    class-methods class_setup.
    class-METHODS class_teardown.

endclass.


class ltcl_ implementation.



  method class_setup.
    go_bgpf_test_env = cl_bgmc_test_environment=>create_for_spying( ).
  endmethod.

  method class_teardown.
    go_bgpf_test_env->destroy( ).

  endmethod.

  method execute.
    data lo_cut type ref to zcl_flight_operation_contr.
    data lo_process_act type ref to if_bgmc_process_spy.

    lo_cut = new zcl_flight_operation_contr( i_flight_keys = value #( carrier_id = 'AA'
                                                                              connection_id = '15'
                                                                              flight_date = '20240802' ) ).

  endmethod.

  method teardown.
    go_bgpf_test_env->clear( ).

  endmethod.

endclass.
