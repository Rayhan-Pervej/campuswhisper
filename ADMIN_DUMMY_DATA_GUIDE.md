# Admin Dummy Data Page - Quick Guide

## Overview
A dedicated admin page has been created to populate Firebase with dummy data for testing. This page can be accessed from the More tab and allows you to add or delete all dummy data with one click.

## Files Created

### 1. DummyDataService
**Location:** `lib/core/services/dummy_data_service.dart`

This service generates realistic dummy data for all models:
- **Posts:** 30 items (Questions, Discussions, Announcements)
- **Events:** 15 items (Academic, Cultural, Sports, Workshops, Seminars)
- **Competitions:** 10 items (Programming, Design, Business, Sports, Gaming)
- **Clubs:** 8 items (Academic, Cultural, Sports, Social, Technology)
- **Lost & Found:** 15 items (Electronics, Documents, Accessories, Books, Keys)
- **Comments:** 20 items (linked to posts)

**Total:** 98 items will be added to Firebase

### 2. AdminDummyDataPage
**Location:** `lib/ui/pages/admin/admin_dummy_data_page.dart`

A clean UI page with:
- Warning card (Development only notice)
- Info card (Shows what will be added)
- Results card (Shows count of items added)
- Add button (Adds all dummy data)
- Delete button (Removes all dummy data)

## How to Use

### Step 1: Navigate to the Admin Page
1. Open the app
2. Go to the **More** tab (bottom navigation)
3. Scroll down to **Developer Tools** section
4. Tap on **Admin - Dummy Data**

### Step 2: Add Dummy Data
1. Review what will be added (shown in the info card)
2. Tap **"Add All Dummy Data"** button
3. Confirm the action in the dialog
4. Wait for the process to complete (shows loading indicator)
5. Success! You'll see a results card showing counts

### Step 3: Test Your App
After adding dummy data, all your pages should show:
- Posts in the Thread page
- Events in the Events page
- Competitions in the Competitions page
- Clubs in the Clubs page
- Lost & Found items in the Lost & Found page
- Comments on posts

### Step 4: Delete Dummy Data (Optional)
1. Tap **"Delete All Dummy Data"** button
2. Confirm the deletion
3. All dummy data will be removed from Firebase

## Sample Data Details

### Posts
- Types: Question, Discussion, Announcement
- Includes titles and content
- Random upvote/downvote counts
- Created by 5 different users
- Posted over the last 30 days

### Events
- Categories: Academic, Cultural, Sports, Workshop, Seminar
- Various locations on campus
- Future and past events
- Attendee tracking
- Max capacity settings

### Competitions
- Categories: Programming, Design, Business, Sports, Gaming
- Registration deadlines
- Prize information
- Team-based and individual
- Participant tracking

### Clubs
- Categories: Academic, Cultural, Sports, Social, Technology
- Contact information
- Member and admin lists
- Established dates

### Lost & Found Items
- Categories: Electronics, Documents, Accessories, Books, Keys
- Both "Lost" and "Found" items
- Location information
- Active and Resolved statuses

### Comments
- Linked to posts
- Includes upvotes/downvotes
- Created by different users
- Posted at various times

## Important Notes

### ⚠️ Development Only
- This page is for **development and testing purposes only**
- **REMOVE THIS PAGE before production deployment**
- The page includes a warning card to remind you

### 🗑️ Cleanup Before Production
To remove the admin page before production:

1. Delete the files:
   - `lib/ui/pages/admin/admin_dummy_data_page.dart`
   - `lib/core/services/dummy_data_service.dart`
   - `ADMIN_DUMMY_DATA_GUIDE.md` (this file)

2. Remove from `lib/routing/app_routes.dart`:
   - Import statement for AdminDummyDataPage
   - Route constant: `static const String adminDummyData = '/admin_dummy_data';`
   - Route case in switch statement

3. Remove from `lib/ui/pages/more/more_page.dart`:
   - The entire "Developer Tools" section

## Troubleshooting

### Data not showing up?
- Check Firebase console to verify data was added
- Ensure your repositories are correctly configured
- Check that providers are registered in main.dart

### Getting errors when adding data?
- Verify Firebase is properly initialized
- Check internet connection
- Ensure all repositories are imported correctly
- Look at console logs for specific error messages

### Delete not working?
- Ensure you have proper Firebase permissions
- Check that collection names match in the service

## Next Steps

After adding dummy data:
1. Test all list pages (Thread, Events, Clubs, Competitions, Lost & Found)
2. Test pagination (scroll to load more items)
3. Test pull-to-refresh functionality
4. Test filters and search
5. Test detail pages
6. Implement comment UI on detail pages

## Firebase Collections

The dummy data will create/populate these Firestore collections:
- `posts`
- `events`
- `competitions`
- `clubs`
- `lost_found_items`
- `comments`

You can view these in your Firebase Console under Firestore Database.

---

**Created:** 2026-01-11
**Status:** Ready to use
**Remember:** Remove before production! 🚀
