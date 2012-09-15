/*
 * Copyright (C) 2012-2012, Intercom Srl, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *          Lele Forzani <lele@windmill.it>
 *          Alfredo Cerutti <acerutti@intercom.it>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Asgard.Flarc.Championship.Flight.Cid2012.Form', {
  extend: 'Asgard.form.ModelFormPanel',
  requires: [
    'Asgard.Flarc.Plugin',
    'Flarc.Championship',
  ],
  model: 'Flarc.Chapionship.Flight',
  record: {
    _type: 'Flarc::Championship::Flight::Cid2012',
  },

  items: [
   {
    xtype: 'combobox',
    fieldLabel: 'Status',
    name: 'status',
    width: 370,
    queryMode: 'local',
    store: [
     [ 'pending', 'Pending' ],
     [ 'approved', 'Approved' ],
     [ 'invalid', 'Invalid' ],
    ],
   },
   {
    xtype: 'engnumberfield',
    name: 'distance',
    fieldLabel: 'Distance',
    anchor: '100%',
    allowBlank: false,
    unit: 'm',
   },
   {
    xtype: 'combobox',
    fieldLabel: 'Ranking',
    name: 'cid_ranking',
    width: 370,
    queryMode: 'local',
    store: [
     [ 'prom', 'Promozione' ],
     [ 'naz_open', 'Nazionale Open' ],
     [ 'naz_15m', 'Nazionale 15 m' ],
     [ 'naz_13m5', 'Nazionale 13.5 m' ],
     [ 'naz_club', 'Nazionale Club' ],
    ],
   },
   {
    xtype: 'combobox',
    fieldLabel: 'Task Type',
    name: 'cid_task_type',
    width: 370,
    queryMode: 'local',
    store: [
     [ 'butterfly', 'Farfalla' ],
     [ 'simple_triangle', 'Triangolo semplice' ],
     [ 'round_trip', 'Andata e ritorno' ],
     [ 'fai_triangle', 'Triangolo FAI' ],
     [ 'straight_line', 'Linea retta' ],
    ],
   },
   {
    xtype: 'combobox',
    fieldLabel: 'Task Evaluation',
    name: 'cid_task_eval',
    width: 370,
    queryMode: 'local',
    store: [
     [ 'free', 'Libero' ],
     [ 'not_completed', 'Dichiarato ma non completato' ],
     [ 'completed', 'Dichiarato e completato' ],
    ],
   },
  ],
});
