% Đọc dữ liệu từ tệp Excel
[data, header] = xlsread('data1.xlsx');

% Vẽ đồ thị so sánh 2 cột giá trị
plot(data(:,1), 'r', 'LineWidth', 1);
hold on;
plot(data(:,2), 'b', 'LineWidth', 1);

% Thêm tiêu đề, nhãn trục và chú thích
title('Biểu đồ so sánh 2 trước và sau loc');
xlabel('Thời gian');
ylabel('Nhiet do');
legend(header{1}, header{2});
