import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Load the dataset
df = pd.read_csv('/kaggle/input/lastpartscoring/test_scores.csv')

# Clean column names (optional, to handle inconsistent spaces and delimiters)
df.columns = df.columns.str.strip()

# Function to pivot data
def pivot_test_data(df):
    # Pivot table to have Test ID and Subject with their respective Total Scores
    pivot_df = df.pivot_table(index='Test ID', columns='Subject', values='Total Score')
    # Fill missing values with 0 for subjects that might not have data for some Test IDs
    pivot_df.fillna(0, inplace=True)
    return pivot_df

# Pivot the data for further processing
pivot_df = pivot_test_data(df)

# Function to simulate test score improvements over time
def simulate_test_scores(df, weeks=10):
    data = []
    subjects = df.columns.tolist()  # Get all subjects dynamically from the pivoted data
    
    for test_id in df.index:
        for week in range(1, weeks + 1):
            week_data = {'Week': week, 'Test_ID': test_id}
            for subject in subjects:
                # Base initial score for each subject for the Test ID
                base_score = df.loc[test_id, subject] if subject in df.columns else 0
                if base_score == 0:  # Avoid starting from 0 for better visualization
                    base_score = np.random.randint(50, 70)
                # Improvement logic: simulate a gradual improvement with random fluctuation
                improvement = min(20, week * 1.5)  # Maximum improvement over time
                fluctuation = np.random.randint(-3, 6)  # Random fluctuation between -3 and 5
                score = min(100, max(0, base_score + improvement + fluctuation))  # Clamp between 0 and 100
                week_data[subject] = score
            data.append(week_data)
    
    return pd.DataFrame(data)

# Simulate the data for 10 weeks
simulated_scores = simulate_test_scores(pivot_df, weeks=10)

# Plot function for a specific Test ID
def plot_test_performance(df, test_id):
    # Filter the data for the specific Test ID
    test_df = df[df['Test_ID'] == test_id]
    
    plt.figure(figsize=(12, 6))
    
    # Plot the performance in each subject
    for subject in pivot_df.columns:
        plt.plot(test_df['Week'], test_df[subject], marker='o', label=subject)
    
    plt.title(f"Test {test_id}'s Performance Over Time")
    plt.xlabel("Week")
    plt.ylabel("Score")
    plt.ylim(50, 100)  # Adjust y-axis limits for better visualization
    plt.legend()
    plt.grid(True)
    
    # Add text annotations for final scores
    for subject in pivot_df.columns:
        final_score = test_df[subject].iloc[-1]
        plt.annotate(f'{final_score:.1f}', (test_df['Week'].iloc[-1], final_score),
                     textcoords="offset points", xytext=(0,10), ha='center')

    plt.tight_layout()
    plt.show()

# Example: Plot the performance for a specific test (e.g., Test ID 101)
test_id = 101  # Change this to any test ID from the dataset
plot_test_performance(simulated_scores, test_id)

# Display the simulated scores for verification
print(simulated_scores.head())
