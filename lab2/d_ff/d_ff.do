restart -f

#写一个周期为20ns完成10切换的clk信号
force clk 0 0ns, 1 5ns -repeat 10ns  

# Test Case 1: Active low reset when q is low
force reset 0 0ns  
force d 0  
run 20ns   

# Test Case 2: Release reset and observe q
force reset 1  
run 10ns  

# Test Case 3: Change d to 1
force d 1  
run 20ns  

# Test Case 4: Activate reset while q is high
force reset 0  
run 20ns  

# Test Case 5: Release reset and change d to 0
force reset 1  
force d 0  
run 20ns  

# Test Case 6: Change d to 1 while reset is not active
force d 1  
run 20ns  1

# Test Case 7: Ensure q remains 1 if no reset or clock edge
run 30ns  

# Test Case 8: Apply reset when q is 1
force reset 0  
run 20ns  

# Finish the simulation
run 100ns  
