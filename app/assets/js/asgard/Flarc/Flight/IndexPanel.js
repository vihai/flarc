/*
 * Flarc
 *
 * Copyright (C) 2009-2011 Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Asgard.Flarc.Flight.IndexPanel', {
  extend: 'Asgard.index.GridPanelBase',
  requires: [
    'Asgard.Flarc.Plugin',
    'Flarc.Flight',
    'Flarc.Plane',
    'Flarc.PlaneType',
    'Flarc.Pilot',
    'Ygg.Core.Person',
  ],
  title: 'Flights',
  model: 'Flarc.Flight',
  columns: [
   {
    xtype: 'datecolumn',
    text: 'Takeoff',
    dataIndex: 'takeoff_time',
    format: 'Y-m-d h:m:s',
    width: 150,
    filterable: true,
   },
   {
    xtype: 'datecolumn',
    text: 'Landing',
    dataIndex: 'landing_time',
    format: 'Y-m-d h:m:s',
    width: 150,
    filterable: true,
   },
   {
    xtype: 'templatecolumn',
    text: 'Pilot',
    dataIndex: 'pilot',
    tpl: '<tpl if="pilot">{pilot.name.first} {pilot.name.last}</tpl>',
    flex: 1,
   },
   {
    xtype: 'templatecolumn',
    text: 'Plane',
    dataIndex: 'plane',
    tpl: '{plane.registration}',
   },
//   {
//    xtype: 'templatecolumn',
//    text: 'Distance',
//    dataIndex: 'distance',
//    tpl: '{distance/1000} km',
//   },

/*   {
    text: 'Name',
    searchIn: [ 'first_name', 'last_name' ], // Temporary until we also decouple search form actual record schema
    tpl: '{name.first} {name.last}',
    xtype: 'stringtemplatecolumn',
    flex: 1,
    filterable: true,
    searchable: true,
   },
   {
    text: 'Italian fiscal code',
    dataIndex: 'italian_fiscal_code',
    filterable: true,
    searchable: true,
    width: 130,
   },*/
  ],
});
