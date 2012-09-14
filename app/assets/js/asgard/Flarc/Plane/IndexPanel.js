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

Ext.define('Asgard.Flarc.Plane.IndexPanel', {
  extend: 'Asgard.index.GridPanelBase',
  requires: [
    'Asgard.Flarc.Plugin',
    'Flarc.Plane',
    'Flarc.PlaneType',
  ],
  title: 'Planes',
  model: 'Flarc.Plane',
  columns: [
   {
    xtype: 'stringcolumn',
    text: 'Registration',
    dataIndex: 'registration',
    filterable: true,
    searchable: true,
   },
   {
    xtype: 'templatecolumn',
    text: 'Type',
    dataIndex: 'plane_type',
    tpl: '{plane_type.name}',
   },
  ],
});
