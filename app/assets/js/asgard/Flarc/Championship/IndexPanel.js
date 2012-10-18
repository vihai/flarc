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

Ext.define('Asgard.Flarc.Championship.IndexPanel', {
  extend: 'Asgard.index.GridPanelBase',
  requires: [
    'Asgard.Flarc.Plugin',
    'Flarc.Championship',
  ],
  title: 'Championships',
  model: 'Flarc.Championship',
  storeConfig: {
    sorters: {
      property: 'valid_from',
      direction: 'ASC',
    },
  },
  columns: [
   {
    text: 'Name',
    dataIndex: 'name',
    flex: 1,
    searchable: true,
    filterable: true,
   },
   {
    xtype: 'datecolumn',
    text: 'Valid From',
    dataIndex: 'valid_from',
    filterable: true,
   },
   {
    xtype: 'datecolumn',
    text: 'Valid To',
    dataIndex: 'valid_to',
    filterable: true,
   },
  ],
});
