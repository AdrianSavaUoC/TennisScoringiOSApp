An iPhone application that keeps track of and calculate scores for a tennis 
match. 
This app:
• Correctly displays the score for the current game, the current set, the match (i.e., total sets won), and 
show all preceding set scores – note that possible scores for any given player in a game will be 
0,15,30,40 or A (Advantage).   
• Detects the end of each game and progress automatically.   
• Detects the end of each set and progress automatically.   
• Correctly detects the end of the match and disable the buttons to add points. Note that this could be 
after 3, 4 or 5 sets depending on the number of sets won by each player.   
• Handles the 6-6 tiebreaks (the first player to score 7 points and be 2 points clear of their opponent wins 
the tiebreak). Tiebreak points must be displayed in the existing points labels.  
• Visually identifies who should serve next at any given point in the game by changing the background 
colour of the player’s name label to the named UIColor ‘purple’.  
• Service changes after every game, regardless of any change in set.  
• Service changes within a tiebreak: The player who was due to serve serves the first point, service 
then changes, and alternates after every 2 further points played.  
• Tiebreak is treated as having the game been served by the player who served first in the tiebreak.  
• An audible alert (the provided sound.wav file) indicates a change in server.  
• The application visually indicates if a player has one or more game points, set points, or match 
points by setting the background colour of the applicable player’s point, game or set label to the 
named UIColor ‘green’.  
• Notifies the user of the winner upon completion of the match, using a UIAlertController. Do not restart 
the game upon dismissing of the alert controller (i.e., leave the set scores visible).   
• Provide an option to display the scoring on an additional screen attached to the iOS device. 
• Allows the user to restart the match at any point. Do not require any confirmation upon pressing the 
restart button. 
• Keeps a history of match scores using persistent storage and allow the user to retrieve them. 
• Uses the device’s calendar and location services, to enhance the application. 
• Schedules a future match and add it to the device’s calendar.  Includes a display at the end of the game to notify 
the user of the future match. 
• Automatically displays the location (country) where the future match will be played.  Display the current country 
where the match is taking place and notify the user of the location (country) for the future match 
• Adds new UI elements to display the future match and location.  All new elements are visible.  
The location element is updateable to show the new location when the user selects a new 
match. 
• Includes comprehensive unit tests
