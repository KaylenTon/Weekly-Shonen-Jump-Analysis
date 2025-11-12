library(ggplot2)
library(ggthemes)

time_series_weekly_circulation_by_year <- circulation_figures_cleaned %>% 
  select(Year, Weekly_Circulation)

ggplot(time_series_weekly_circulation_by_year, aes(Year, Weekly_Circulation)) + 
  # Use geom_segment for a "range-frame" style axis (more Tufte-like for the frame)
  # but geom_line is fine for the main data
  geom_line(color = "dark blue", linewidth = 1) + 
  geom_point(size = 3, color = "maroon") + 
  # Set a clean, minimalist Tufte theme
  theme_tufte(base_size = 14) +
  # Remove axis labels (as per your original code)
  theme(axis.title = element_blank(),
        # For a truly minimal look, you might remove the axis ticks/lines too
        axis.line = element_blank(),
        axis.ticks = element_blank()) +
  # Add horizontal lines as reference (often preferred over full grid lines)
  geom_hline(yintercept = c(5000000, 6530000), linetype = 2, color = "gray60") + 
  # Adding a vertical line between 1989 and 1996
  geom_vline(xintercept = c(1989, 1996), linetype = 2, color = "gray60") + 
  # Set consistent, easy-to-read breaks for Y axis
  scale_y_continuous(breaks = seq(0, 60000000, 1000000), 
                     # Use labels for currency or unit clarity
                     labels = scales::unit_format(unit = "M", scale = 1e-6)) +
  # Set consistent breaks for X axis
  scale_x_continuous(breaks = seq(1950, 2010, 5)) +
  # Optional: Add a title/caption, often placed in a margin in Tufte-style
  labs(
    title = "Shonen Jump Weekly Circulation From Years 1986 - 2007",
    caption = "Tufte Minimalistic Theme"
  )

# Next steps: Make these times series more intentional. Mark shonen jump's 'golden' years and do a time series for multiple variables, grid them, and annotate on the charts.