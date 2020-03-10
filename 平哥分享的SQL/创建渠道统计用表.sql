create table warehouse_atomic_statistics_chan_info
(    statistics_chan varchar(100) primary KEY,
     merger_chan varchar(100),
	 chan_no_desc varchar(60),
	 child_chan varchar(30),
	 2nd_level varchar(20)
)
