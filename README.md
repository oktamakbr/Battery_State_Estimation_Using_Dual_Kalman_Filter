# battery-state-estimation-using-dual-kalman-filter
I made this personal project to estimate state of charge and internal resistivity of a battery in MATLAB. I use the algorithm by modifying the code from Plett and implement it by using open published data from Stanford. The goal is to get root mean square error as mininum as possible. First, I extract the SOC and OCV curve from diagnostic test data. Then, by using UDDS cycle test data, I get the battery parameter with recursive least square method. Lastly, I successfully estimate SOC and R0 using dual sigma point kalman filter and get good rms error.

## state of health
