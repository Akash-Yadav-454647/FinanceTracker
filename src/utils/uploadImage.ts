import { supabase } from "../lib/supabase";

/**
 * Uploads an image to Supabase storage and returns the public URL
 * @param file The file to upload
 * @param bucket The storage bucket name (default: 'receipts')
 * @param userId The user ID to use in the file path
 * @returns The public URL of the uploaded image
 */
export async function uploadImage(
  file: File,
  bucket: string = "receipts",
  userId: string
): Promise<string | null> {
  try {
    if (!file) return null;

    // Create a unique file name
    const fileExt = file.name.split(".").pop();
    const fileName = `${userId}/${Math.random()
      .toString(36)
      .substring(2, 15)}_${Date.now()}.${fileExt}`;

    // Upload the file to Supabase storage
    const { data, error } = await supabase.storage
      .from(bucket)
      .upload(fileName, file, {
        cacheControl: "3600",
        upsert: false,
      });

    if (error) {
      console.error("Error uploading image:", error);
      return null;
    }

    // Get the public URL
    const { data: urlData } = supabase.storage
      .from(bucket)
      .getPublicUrl(fileName);

    return urlData.publicUrl;
  } catch (error) {
    console.error("Error in uploadImage:", error);
    return null;
  }
}
