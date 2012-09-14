/*
 * Copyright (C) 2009-2012 Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Asgard.Flarc.PlaneType.IndexPanel', {
  extend: 'Asgard.index.GridPanelBase',
  requires: [
    'Asgard.Flarc.Plugin',
    'Flarc.PlaneType',
  ],
  title: 'PlaneTypes',
  model: 'Flarc.PlaneType',
  columns: [
   {
    text: 'Name',
    dataIndex: 'name',
    flex: 2,
    filterable: true,
    searchable: true,
   },
   {
    text: 'Manufacturer',
    dataIndex: 'manufacturer',
    flex: 1,
    filterable: true,
    searchable: true,
   },
   {
    xtype: 'numbercolumn',
    text: 'Handicap',
    dataIndex: 'handicap',
    filterable: true,
   },
   {
    xtype: 'numbercolumn',
    text: 'Club Handicap',
    dataIndex: 'club_handicap',
    filterable: true,
   },
  ],
  actions: [
   {
    text: 'New...',
    name: 'new',
   },
  ],
});
