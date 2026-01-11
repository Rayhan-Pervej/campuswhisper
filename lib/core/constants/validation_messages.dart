class ValidationMessages {
  // Email
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Enter a valid email address';

  // Password
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String passwordTooWeak = 'Password is too weak';
  static const String passwordMismatch = 'Passwords do not match';
  static const String confirmPasswordRequired = 'Please confirm your password';

  // Name
  static const String nameRequired = 'Name is required';
  static const String firstNameRequired = 'First name is required';
  static const String lastNameRequired = 'Last name is required';
  static const String nameTooShort = 'Name must be at least 2 characters';

  // Phone
  static const String phoneRequired = 'Phone number is required';
  static const String phoneInvalid = 'Enter a valid phone number (01XXXXXXXXX)';

  // Generic
  static const String fieldRequired = 'This field is required';
  static const String fieldTooShort = 'This field is too short';
  static const String fieldTooLong = 'This field is too long';
  static const String invalidInput = 'Invalid input';

  // Title/Content
  static const String titleRequired = 'Title is required';
  static const String titleTooShort = 'Title must be at least 3 characters';
  static const String titleTooLong = 'Title is too long';
  static const String descriptionRequired = 'Description is required';
  static const String contentRequired = 'Content is required';
  static const String contentTooShort = 'Content is too short';
  static const String contentTooLong = 'Content exceeds maximum length';

  // Date/Time
  static const String dateRequired = 'Date is required';
  static const String timeRequired = 'Time is required';
  static const String invalidDate = 'Invalid date';
  static const String pastDateNotAllowed = 'Past dates are not allowed';
  static const String invalidDateRange = 'Invalid date range';

  // Location
  static const String locationRequired = 'Location is required';
  static const String addressRequired = 'Address is required';

  // File/Image
  static const String imageRequired = 'Image is required';
  static const String fileRequired = 'File is required';

  // Category/Selection
  static const String categoryRequired = 'Category is required';
  static const String selectionRequired = 'Please make a selection';

  // URL
  static const String urlInvalid = 'Enter a valid URL';

  // Number
  static const String numberInvalid = 'Enter a valid number';
  static const String numberTooSmall = 'Number is too small';
  static const String numberTooLarge = 'Number is too large';

  // Scholarship/CGPA Specific
  static const String cgpaRequired = 'CGPA is required';
  static const String cgpaInvalid = 'Enter a valid CGPA (0.00 - 4.00)';
  static const String gradeRequired = 'Grade is required';
  static const String creditRequired = 'Credit hours required';
  static const String creditInvalid = 'Enter valid credit hours';

  // Course Specific
  static const String courseNameRequired = 'Course name is required';
  static const String courseCodeRequired = 'Course code is required';
  static const String semesterRequired = 'Semester is required';

  // Event Specific
  static const String eventNameRequired = 'Event name is required';
  static const String eventDateRequired = 'Event date is required';
  static const String eventLocationRequired = 'Event location is required';
  static const String eventDescriptionRequired = 'Event description is required';

  // Competition Specific
  static const String competitionNameRequired = 'Competition name is required';
  static const String registrationDeadlineRequired = 'Registration deadline is required';
  static const String maxParticipantsRequired = 'Maximum participants required';

  // Lost & Found Specific
  static const String itemNameRequired = 'Item name is required';
  static const String itemDescriptionRequired = 'Item description is required';
  static const String contactInfoRequired = 'Contact information is required';

  // Comment/Post Specific
  static const String commentRequired = 'Comment cannot be empty';
  static const String commentTooLong = 'Comment is too long';
  static const String postContentRequired = 'Post content is required';

  // Course Routine Specific
  static const String courseIdRequired = 'Course ID is required';
  static const String sectionRequired = 'Section is required';
  static const String roomRequired = 'Room is required';
  static const String daysRequired = 'Please select at least one day';
  static const String startTimeRequired = 'Start time is required';
  static const String endTimeRequired = 'End time is required';
  static const String semesterNameRequired = 'Semester name is required';
}
