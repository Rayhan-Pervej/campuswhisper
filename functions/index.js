/**
 * Firebase Cloud Functions for CampusWhisper
 *
 * This function sends FCM notifications when new comments/replies are created
 */

const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {onSchedule} = require("firebase-functions/v2/scheduler");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore, FieldValue} = require("firebase-admin/firestore");
const {getMessaging} = require("firebase-admin/messaging");

initializeApp();

/**
 * Send FCM notifications from Firestore queue
 *
 * Triggers when a new document is created in the 'notifications' collection
 * Sends the notification via FCM and marks it as sent
 */
exports.sendNotification = onDocumentCreated(
    "notifications/{notificationId}",
    async (event) => {
      const notification = event.data.data();

      // Check if already sent
      if (notification.sent) {
        console.log("Notification already sent:",
            event.params.notificationId);
        return null;
      }

      try {
        // Prepare FCM message
        const message = {
          token: notification.token,
          notification: {
            title: notification.notification.title,
            body: notification.notification.body,
          },
          data: notification.data || {},
          android: {
            priority: "high",
            notification: {
              channelId: "campuswhisper_channel",
              sound: "default",
              priority: "high",
            },
          },
          apns: {
            payload: {
              aps: {
                sound: "default",
                badge: 1,
              },
            },
          },
        };

        // Send notification
        const response = await getMessaging().send(message);
        console.log("✅ Notification sent successfully:", response);

        // Mark as sent
        await event.data.ref.update({
          sent: true,
          sentAt: FieldValue.serverTimestamp(),
          response: response,
        });

        return response;
      } catch (error) {
        console.error("❌ Error sending notification:", error);

        // Mark as failed
        await event.data.ref.update({
          sent: false,
          error: error.message,
          failedAt: FieldValue.serverTimestamp(),
        });

        return null;
      }
    });

/**
 * Clean up old notifications (optional)
 * Runs daily to delete notifications older than 7 days
 */
exports.cleanupOldNotifications = onSchedule(
    "every 24 hours",
    async (event) => {
      const db = getFirestore();
      const sevenDaysAgo = new Date();
      sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

      const snapshot = await db
          .collection("notifications")
          .where("createdAt", "<", sevenDaysAgo)
          .get();

      const batch = db.batch();
      snapshot.docs.forEach((doc) => {
        batch.delete(doc.ref);
      });

      await batch.commit();
      console.log(`🗑️ Deleted ${snapshot.size} old notifications`);

      return null;
    });
