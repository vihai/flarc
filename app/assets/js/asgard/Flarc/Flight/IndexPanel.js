/*
 * Flarc
 *
 * Copyright (C) 2009-2012 Daniele Orlandi
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
    'Flarc.Championship',
    'Ygg.Core.Person',
  ],
  title: 'Flights',
  model: 'Flarc.Flight',
  storeConfig: {
    sorters: {
      property: 'takeoff_time',
      direction: 'DESC',
    },
  },
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
    tpl: '<tpl if="pilot">{pilot.name.first} {pilot.name.last}</tpl>',
    flex: 1,
    sortable: true,
    searchable: true,
    searchIn: [ 'pilot.last_name', 'pilot.first_name' ],
    getSortParam: function() {
      return [ 'pilot.last_name', 'pilot.first_name' ];
    },
   },
   {
    xtype: 'templatecolumn',
    text: 'Championships',
    tpl: '<tpl for="championship_flights"><tpl for="championship">{name}</tpl> {distance / 1000} km</tpl>',
    flex: 2,
    sortable: true,
    searchable: true,
    searchIn: [ 'championship_flights.championship.name' ],
    getSortParam: function() {
      return 'championships.name';
    },
   },
   {
    xtype: 'templatecolumn',
    text: 'Plane',
    dataIndex: 'plane',
    tpl: '{plane.registration}',
    sortable: false,
   },
  ],
});
