restart -f

#写一个周期为20ns完成10切换的clk信号
force clk 0 0ns, 1 5ns -repeat 10ns

#这是一个jk触发器，所以要有j和k reset q
#reset未被按下时为1，按下时为0

# Test Case 1: 复位
force reset 0 0ns
force j 0
force k 0
run 20ns

# Test Case 2: 释放复位
force reset 1
run 20ns

# Test Case 3: j=0,k=0这是一个保持状态
force j 0
force k 0
run 20ns

# Test Case 4: j=0,k=1这是一个置0状态
force j 0
force k 1
run 20ns

# Test Case 5: j=1,k=0这是一个置1状态
force j 1
force k 0
run 20ns

# Test Case 3: j=0,k=0这是一个保持状态
force j 0
force k 0
run 20ns


# Test Case 6: j=1,k=1这是一个切换状态
force j 1
force k 1
run 20ns

# Test Case 7: j=1,k=1这是一个切换状态
force j 1
force k 1
run 20ns
