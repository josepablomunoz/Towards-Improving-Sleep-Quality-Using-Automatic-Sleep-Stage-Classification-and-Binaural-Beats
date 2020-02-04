function big_buf = AppendandShift (big_buf, little_buf);

num_shift = length(little_buf);
final = length(big_buf) - num_shift;

for i = 1:final
    big_buf(i) = big_buf(i+num_shift);
end
for i  = 1:num_shift
    big_buf(final+i) = little_buf(i);
end
