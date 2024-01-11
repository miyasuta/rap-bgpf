@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flight Occupancy'
define root view entity ZI_FlightOccupancy as select from /DMO/I_Flight as flight
left outer many to one join zflightoccupancy as occupancy
on flight.AirlineID = occupancy.carrier_id
and flight.ConnectionID = occupancy.connection_id
and flight.FlightDate = occupancy.flight_date
{
    key flight.AirlineID,
    key flight.ConnectionID,
    key flight.FlightDate,
    flight.Price,
    flight.CurrencyCode,
    flight.PlaneType,
    flight.MaximumSeats,
    flight.OccupiedSeats,
    occupancy.calc_status as CalcStatus,
    @EndUserText.label: 'Calculation Status'
    case occupancy.calc_status
      when '1' then 'Processing'
      when '2' then 'Done' 
      when '3' then 'Error' 
      else 'None'
      end as CalcStatusDisp,    
    case occupancy.calc_status
      when '1' then 2 //processing: warning
      when '2' then 3 //done: positive
      when '3' then 1 //error: critical
      else 0
      end as Criticality,
    @Semantics.quantity.unitOfMeasure: 'OccupancyUnit'
    @EndUserText.label: 'Occupancy Rate'
    occupancy.occupancy_rate as OccupancyRate,  
    occupancy.occupancy_unit as OccupancyUnit,    
    /* Associations */
    flight._Airline,
    flight._Connection,
    flight._Currency
}
