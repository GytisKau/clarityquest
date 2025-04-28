# Clarity Quest Game

## How to Download Godot and Export the Web Build

### Step 1: Download Godot

1. Visit the [official Godot Engine website](https://godotengine.org/).
2. Navigate to the **Download** section.
3. Choose the appropriate version for your operating system (e.g., Windows, macOS, Linux). Tinka bet kokia - daryta ant Windows.
4. Download the stable version (e.g., 4.4 Stable).
5. Extract the downloaded file and run the Godot executable.

### Step 2: Open the Project

1. Launch Godot.
2. Click on **Import** and navigate to the folder containing the `project.godot` file for this game.
3. Select the file and click **Open**.

### Step 3: Install Export Templates

1. In Godot, go to **Editor** > **Manage Export Templates**.
2. Click **Download and Install** to get the latest export templates.

### Step 4: Configure the Web Export

1. Set the output path for the exported files.  
   Example: `export_path="../xampp/htdocs/ClarityQuest/index.html"`

### Step 5: Test the project

1. Try to run the game on your own platform:  
   Top right triangle `Run Project (F5)`
2. Try to run on local host (Database tracking probobly wont work but thats okay):  
   Top right `Remote Deploy` -> `Run in Browser`

### Step 6: Export the Web Build

1. Click **Export Project** in the Export window.
2. Choose a destination folder for the exported files.  
   Example: `../xampp/htdocs/ClarityQuest`
3. Wait for the export process to complete.

### Step 7: Setup the config folder

1. Create a config file called `db_config.php` and add it as a sibling to your exported game folder  
   Example: `../xampp/htdocs/config/db_config.php`.
2. Enter your database details:

```php
<?php
return [
    'servername' => 'localhost',
    'username' => 'root',
    'password' => '',
    'database' => 'mzqjuzmf_think_twice'
];
?>
```

### Step 7: Test the Web Build

1. Open the game in a web browser to ensure it runs correctly.

## Question editing

### File paths and naming

Questions should be contained in JSON files located in `./questions/[language]/[level].json` files.

### Level structure

The first level `Level 1` contains three level types:

```yaml
{
  "ChooseTheCorrectAnswer": [...],
  "MultipleChoice": [...],
  "FillInTheBlank_corrected": [...]
}
```

`Level 2` and `Level 3` contain these three level types:

```yaml
{
  "ChooseTheCorrectAnswer": [...],
  "MultipleChoice": [...],
  "FillInTheBlank": [...]
}
```

The `FillInTheBlank_corrected` question type is the same as the `ChooseTheCorrectAnswer` level type for the first level.

### `ChooseTheCorrectAnswer` structure

```yaml
{
  "ChooseTheCorrectAnswer": [
	{
	  "author": "author1", // string: The author is not showed in the game
	  "topic": "Topic1",   // string: The topic of this question group
	  "questions": [       // object array: The questions of this group
		{
		  "question": "Question1",        // string: Question
		  "options": ["A" "B", "C", "D"], // strings array: Answers to pick
		  "correctOption": "A",           // string: The correct string from "options"
		  "feedback_incorrect": "Wrong!", // string: Feedback when guessed incorrectly
		  "feedback_correct": "Correct!"  // string: Feedback when guessed correctly
		},
		{
		  "question": "Question2",
		  "options": ["E" "F", "G", "H"],
		  "correctOption": "G",
		  "feedback_incorrect": "Wrong!",
		  "feedback_correct": "Correct!"
		}]
	},
	{
	  "author": "author2",
	  "topic": "Topic2",
	  "questions": [
		{
		  "question": "Question3",
		  "options": ["I" "J", "K", "L"],
		  "correctOption": "L",
		  "feedback_incorrect": "Wrong!",
		  "feedback_correct": "Correct!"
		},
		{
		  "question": "Question4",
		  "options": ["M" "N", "O", "P"],
		  "correctOption": "M",
		  "feedback_incorrect": "Wrong!",
		  "feedback_correct": "Correct!"
		}]
	}]
}
```

### `MultipleChoice` structure

Only diferance between `ChooseTheCorrectAnswer` and `MultipleChoice` is the multple correct answer array:  
`"correctOption": "A"` -> `"answers": ["A" "C"]`

```yaml
{
  "MultipleChoice": [
	{
	  "author": "author1", // string: The author is not showed in the game
	  "topic": "Topic1",   // string: The topic of this question group
	  "questions": [       // object array: The questions of this group
		{
		  "question": "Question1",        // string: Question
		  "options": ["A" "B", "C", "D"], // strings array: Answers to pick
		  "answers": ["A" "C"],           // strings array: Correct answers values
		  "feedback_incorrect": "Wrong!", // string: Feedback when guessed incorrectly
		  "feedback_correct": "Correct!"  // string: Feedback when guessed correctly
		},
		{
		  "question": "Question2",
		  "options": ["E" "F", "G", "H"],
		  "answers": ["G" "H"],
		  "feedback_incorrect": "Wrong!",
		  "feedback_correct": "Correct!"
		}]
	},
	{
	  "author": "author2",
	  "topic": "Topic2",
	  "questions": [
		{
		  "question": "Question3",
		  "options": ["I" "J", "K", "L"],
		  "answers": ["I" "L"],
		  "feedback_incorrect": "Wrong!",
		  "feedback_correct": "Correct!"
		},
		{
		  "question": "Question4",
		  "options": ["M" "N", "O", "P"],
		  "answers": ["O" "N"],
		  "feedback_incorrect": "Wrong!",
		  "feedback_correct": "Correct!"
		}]
	}]
}
```

### `FillInTheBlank` structure

```yaml
{
 "FillInTheBlank": [
	{
	  "author": "Author1", // string: The author is not showed in the game
	  "topic": "Topic1",   // string: The topic of this question group
	  "questions": [       // object array: The questions of this group
		{
		  "question": "Question1: First blank _ and second blank _.", // string: Question with blanks '_'
		  "answers": [          // array of arrays: Answers for each blank
				["A1", "A2", "A3"], // string array: Answers for the first blank
				["B1", "B2", "B3"]  // string array: Answers for the second blank
			],
		  "feedback_incorrect": "Wrong!", // string: Feedback when guessed incorrectly
		  "feedback_correct": "Correct!"  // string: Feedback when guessed correctly
		},
		{
		  "question": "Question2: First blank _ and second blank _.",
		  "answers": [
				["C1", "C2", "C3"],
				["D1", "D2", "D3"]
			],
		  "feedback_incorrect": "Wrong!",
		  "feedback_correct": "Correct!"
		}]
	}]
}
```

### `FillInTheBlank_corrected` structure

The `FillInTheBlank_corrected` question type is the same as the `ChooseTheCorrectAnswer` level type.

## UI translations

### File paths and naming

UI translations are located in `./Translations/[language].json`

### UI translations in gdscript

These UI tranlsations are loaded in a global dictionary `Global.translations` and are automatically swapped based on the current selected language in the main menu.

```py
# When EN
Global.translation["Correct"] => "Correct"
# When LT
Global.translation["Correct"] => "Teisingai"
```
