# ==============================================================================
# COURSERA - EXPLORATORY DATA ANALYSIS - COURSE PROJECT 1
# ==============================================================================

# 1. TẢI VÀ GIẢI NÉN DỮ LIỆU (Tự động)
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zip_file <- "household_power_consumption.zip"
txt_file <- "household_power_consumption.txt"

if (!file.exists(txt_file)) {
  message("Đang tải file dữ liệu từ Coursera...")
  download.file(url, zip_file)
  unzip(zip_file)
  message("Giải nén thành công!")
}

# 2. ĐỌC VÀ LỌC DỮ LIỆU
message("Đang đọc dữ liệu vào R...")
all_data <- read.table(txt_file, header = TRUE, sep = ";", 
                       na.strings = "?", colClasses = c(
                         "character", "character", "numeric", "numeric", 
                         "numeric", "numeric", "numeric", "numeric", "numeric"
                       ))

# Lọc dữ liệu chỉ lấy 2 ngày: 2007-02-01 và 2007-02-02
sub_data <- subset(all_data, Date == "1/2/2007" | Date == "2/2/2007")
rm(all_data)

# Chuyển đổi định dạng Date và Time thành chuẩn POSIXlt/POSIXct trong R
date_time <- strptime(paste(sub_data$Date, sub_data$Time, sep=" "), "%d/%m/%Y %H:%M:%S")
sub_data$DateTime <- as.POSIXct(date_time)

# Thiết lập ngôn ngữ hệ thống hiển thị thứ bằng tiếng Anh
Sys.setlocale("LC_TIME", "C")

# ==============================================================================
# VẼ PLOT 4: Kết hợp 4 biểu đồ nhỏ trên cùng 1 giao diện (Mảng 2x2)
# ==============================================================================
message("Đang vẽ Plot 4...")
png("plot4.png", width = 480, height = 480)

par(mfrow = c(2, 2))

# 4.1 Biểu đồ góc trên-trái
plot(sub_data$DateTime, sub_data$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power")

# 4.2 Biểu đồ góc trên-phải
plot(sub_data$DateTime, sub_data$Voltage, type = "l", xlab = "datetime", ylab = "Voltage")

# 4.3 Biểu đồ góc dưới-trái
plot(sub_data$DateTime, sub_data$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering", col = "black")
lines(sub_data$DateTime, sub_data$Sub_metering_2, col = "red")
lines(sub_data$DateTime, sub_data$Sub_metering_3, col = "blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = 1, bty = "n", cex = 0.8)

# 4.4 Biểu đồ góc dưới-phải
plot(sub_data$DateTime, sub_data$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power")

dev.off()
message("Hoàn thành vẽ plot4.png!")