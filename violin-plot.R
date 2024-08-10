# Load the ggplot2 package
library(ggplot2)

# Create a data frame with virus lengths
virus_data <- data.frame(
  Length = c(36084,49137,41349,44293,40868,33648,39989,37118,38176,59467,62752,38584,38223,38397,40261,
             33358,55160,38551,22121,36487,40798,55009,10101,27026,56518,41968,40384,40578,36136,40766,
             75004,54241,74280,65939,41994,35464,45795,37912)  # Replace with your virus lengths
)

length_ranges <- cut(virus_data$Length, breaks = c(10000, 20000, 30000, 40000, 50000,60000,70000,80000), labels = c( "10000-20000", "20001-30000", "30001-40000", "40001-50000", "50001-60000", "60001-70000","70001-80000"))
length_counts <- table(length_ranges)

# Create a violin plot
p <- ggplot(virus_data, aes(x = "", y = Length)) +
  geom_violin(fill = "lightblue") +
  geom_boxplot(width = 0.1, fill = "white", color = "black") +  # Add boxplot for reference
  ylab(expression("Length\\bp")) +
  xlab("Proviruses") +  # Empty label for x-axis
  theme_minimal() +
  theme(axis.text.x = element_blank())  # Hide x-axis labels

p + annotate("text", x = 1.0, y = max(virus_data$Length)+2000, label = paste("Max:", max(virus_data$Length))) +
  annotate("text", x = 1.0, y = min(virus_data$Length)-2000, label = paste("Min:", min(virus_data$Length))) +
  annotate("text", x = 1.5, y = 15000, label = paste("10000-20000:", length_counts[1])) +
  annotate("text", x = 1.5, y = 25000, label = paste("20000-30000:", length_counts[2])) +
  annotate("text", x = 1.5, y = 35000, label = paste("30000-40000:", length_counts[3])) +
  annotate("text", x = 1.5, y = 45000, label = paste("40000-50000:", length_counts[4])) +
  annotate("text", x = 1.5, y = 55000, label = paste("50000-60000:", length_counts[5])) +
  annotate("text", x = 1.5, y = 65000, label = paste("60000-70000:", length_counts[6])) +
  annotate("text", x = 1.5, y = 75000, label = paste("70000-80000:", length_counts[7]))

