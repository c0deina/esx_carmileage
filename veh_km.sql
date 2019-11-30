CREATE TABLE `veh_km` (
  `carplate` varchar(10) NOT NULL,
  `km` varchar(255) NOT NULL DEFAULT '0',
  `state` int(1) NOT NULL DEFAULT '0',
  `reset` int(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `veh_km`
  ADD PRIMARY KEY (`carplate`),
  ADD UNIQUE KEY `carplate` (`carplate`),
  ADD KEY `carplate_2` (`carplate`);
COMMIT;
