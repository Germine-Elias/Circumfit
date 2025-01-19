import cv2
import mediapipe as mp
import numpy as np
import math

# Initialisation de MediaPipe Pose
mp_pose = mp.solutions.pose

def tracer_points(image, landmarks, width, height):
    """
    Trace les points clés détectés par MediaPipe sur l'image avec des croix rouges.

    Args:
        image: Image sur laquelle tracer les points.
        landmarks: Points clés détectés par MediaPipe.
        width: Largeur de l'image.
        height: Hauteur de l'image.
    """
    for landmark in landmarks:
        x = int(landmark.x * width)
        y = int(landmark.y * height)
        cv2.drawMarker(image, (x, y), (0, 0, 255), markerType=cv2.MARKER_CROSS, thickness=2)

        
def mesurer_profondeur_taille(image_path, user_height_cm, image_name="output"):
    """
    Calcule la profondeur (largeur latérale) de la taille d'une personne en vue latérale.

    Args:
        image_path: Chemin vers l'image de profile.
        user_height_cm: Hauteur réelle de la personne en centimètres.
        image_name: Nom pour sauvegarder l'image annotée.

    Returns:
        Largeur de la taille en centimètres ou None si les points clés ne sont pas détectés.
    """
    # Charger l'image
    image = cv2.imread(image_path)
    if image is None:
        raise FileNotFoundError("Image introuvable.")
    image_rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

    # Initialisation de MediaPipe Pose
    with mp_pose.Pose(static_image_mode=True, min_detection_confidence=0.5) as pose:
        results = pose.process(image_rgb)

        if results.pose_landmarks:
            landmarks = results.pose_landmarks.landmark
            height, width, _ = image.shape
            tracer_points(image, landmarks, width, height)

            # Points clés nécessaires
            left_heel = landmarks[mp_pose.PoseLandmark.LEFT_HEEL]
            right_heel = landmarks[mp_pose.PoseLandmark.RIGHT_HEEL]
            left_shoulder = landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER]
            right_shoulder = landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER]
            nose = landmarks[mp_pose.PoseLandmark.NOSE]
            left_hip = landmarks[mp_pose.PoseLandmark.LEFT_HIP]

            # Calcul des coordonnées du sommet de la tête à partir de la distance nez-talons
            heel_y_px = int(((left_heel.y + right_heel.y) / 2) * height)
            nose_y = int(nose.y * height)
            distance_nose_heel = nose_y - heel_y_px
            
            head_y = int(nose_y + (0.1 * distance_nose_heel))  # 10 % ajouté pour estimer la tête
            head_x = int(left_hip.x * width)

            # Tracer le sommet de la tête
            cv2.drawMarker(image, (head_x, head_y), (255, 0, 0), markerType=cv2.MARKER_STAR, thickness=2)
            cv2.putText(image, "Head (estimated)", (head_x + 10, head_y - 10),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 0), 2)
            
            # Calcul de la hauteur totale et du ratio pixel/cm
            person_height_px = abs(heel_y_px - head_y)
            ratio_pixel_cm = user_height_cm / person_height_px

            # Position de la taille à 25 % de la distance épaules-talons
            shoulder_y_px = int(((left_shoulder.y + right_shoulder.y) / 2) * height)
            distance_epaules_talons = abs(heel_y_px - shoulder_y_px)
            waist_y_px = int(shoulder_y_px + (distance_epaules_talons * 0.25))

            # Calcul de la largeur de la taille en pixels
            edges = cv2.Canny(cv2.cvtColor(image, cv2.COLOR_BGR2GRAY), 50, 150) # détection de contours
            x_center = int(width/2)
            x_left, x_right = x_center, x_center
            # part du point central et incrémente de part et d'autres jusqu'à détecter un contour de la silouhette (ligne de la largeur de la taille )
            while x_left > 0 and edges[waist_y_px, x_left] == 0:
                x_left -= 1
            while x_right < width and edges[waist_y_px, x_right] == 0:
                x_right += 1

            # Conversion de la largeur de la taille en centimètres
            waist_width_px = x_right - x_left
            waist_width_cm = waist_width_px * ratio_pixel_cm

            # Annoter et sauvegarde l'image avec les résultats
            cv2.line(image, (x_left, waist_y_px), (x_right, waist_y_px), (0, 255, 0), 3)
            cv2.putText(image, f"{waist_width_cm:.2f} cm", (x_center, waist_y_px - 20),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.8, (0, 255, 0), 2)
            output_path = f"{image_name}_mesure_side.png"
            cv2.imwrite(output_path, image)

            print(f"Profondeur de la taille : {waist_width_cm:.2f} cm")
            return waist_width_cm
        else:
            print("Aucun point de repère détecté.")
            return None


def mesurer_largeur_taille(image_path, user_height_cm, image_name="output"):
    """
    Calcule la largeur de la taille en centimètres pour une vue frontale de la personne.

    Args:
        image_path: Chemin vers l'image frontale.
        user_height_cm: Hauteur réelle de la personne en centimètres.
        image_name: Nom pour sauvegarder l'image annotée.

    Returns:
        Largeur de la taille en centimètres ou None si les points clés ne sont pas détectés.
    """
    # Charger l'image
    image = cv2.imread(image_path)
    if image is None:
        raise FileNotFoundError("Image introuvable.")
    image_rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

    # Initialisation de MediaPipe Pose
    with mp_pose.Pose(static_image_mode=True, min_detection_confidence=0.5) as pose:
        results = pose.process(image_rgb)

        if results.pose_landmarks:
            landmarks = results.pose_landmarks.landmark
            height, width, _ = image.shape
            tracer_points(image, landmarks, width, height)

            # Points clés nécessaires
            left_heel = landmarks[mp_pose.PoseLandmark.LEFT_HEEL]
            right_heel = landmarks[mp_pose.PoseLandmark.RIGHT_HEEL]
            left_shoulder = landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER]
            right_shoulder = landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER]
            nose = landmarks[mp_pose.PoseLandmark.NOSE]

            # Calcul des coordonnées importantes
            shoulder_y_px = int(((left_shoulder.y + right_shoulder.y) / 2) * height)
            heel_y_px = int(((left_heel.y + right_heel.y) / 2) * height)
            nose_y = int(nose.y * height)
            distance_nose_heel = nose_y - heel_y_px
            head_y = int(nose_y + (0.1 * distance_nose_heel))  # 10 % ajouté pour estimer la tête
            head_x = int(nose.x * width)

            # Tracer le sommet de la tête
            cv2.drawMarker(image, (head_x, head_y), (255, 0, 0), markerType=cv2.MARKER_STAR, thickness=2)
            cv2.putText(image, "Head (estimated)", (head_x + 10, head_y - 10),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 0), 2)
            
            # Calcul de la hauteur totale et du ratio pixel/cm
            person_height_px = abs(heel_y_px - head_y)
            ratio_pixel_cm = user_height_cm / person_height_px

            # Position de la taille à 25 % de la distance épaules-talons
            distance_epaules_talons = abs(heel_y_px - shoulder_y_px)
            waist_y_px = int(shoulder_y_px + (distance_epaules_talons * 0.25))

            # Calcul de la largeur de la taille en pixels
            edges = cv2.Canny(cv2.cvtColor(image, cv2.COLOR_BGR2GRAY), 50, 150)
            x_center = int(width / 2)
            x_left, x_right = x_center, x_center
            while x_left > 0 and edges[waist_y_px, x_left] == 0:
                x_left -= 1
            while x_right < width and edges[waist_y_px, x_right] == 0:
                x_right += 1

            # Conversion de la largeur de la taille en centimètres
            waist_width_px = x_right - x_left
            waist_width_cm = waist_width_px * ratio_pixel_cm

            # Annoter l'image avec les résultats
            cv2.line(image, (x_left, waist_y_px), (x_right, waist_y_px), (0, 255, 0), 3)
            cv2.putText(image, f"{waist_width_cm:.2f} cm", (x_center, waist_y_px - 20),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.8, (0, 255, 0), 2)
            output_path = f"{image_name}_mesure_frontale.png"
            cv2.imwrite(output_path, image)

            print(f"Largeur de la taille (frontale) : {waist_width_cm:.2f} cm")
            return waist_width_cm
        else:
            print("Aucun point de repère détecté.")
            return None

def calculer_bri(image_path_side, image_path_front, user_height_cm, image_name="output"):
    """
    Calcule le Body Roundness Index (BRI) à partir des mesures frontale et latérale.

    Args:
        image_path_side: Chemin vers l'image latérale.
        image_path_front: Chemin vers l'image frontale.
        user_height_cm: Hauteur réelle de la personne en centimètres.
        image_name: Nom pour sauvegarder l'image annotée.

    Returns:
        BRI calculé ou None si une des mesures échoue.
    """
    waist_width_side = mesurer_profondeur_taille(image_path_side, user_height_cm, image_name)
    waist_width_front = mesurer_largeur_taille(image_path_front, user_height_cm, image_name)

    if waist_width_side is not None and waist_width_front is not None:
        # Calcul de la circonférence de la taille avec la formule de l'ellipse
        r1, r2 = waist_width_front / 2, waist_width_side / 2
        waist_circumference = 2 * math.pi * math.sqrt((r1**2 + r2**2) / 2)

        # Calcul du BRI
        BRI = 364.2 - 365.5 * ((1 - (waist_circumference / (math.pi * user_height_cm))**2))**0.5

        print(f"Circonférence de la taille : {waist_circumference:.2f} cm")
        print(f"BRI calculé : {BRI:.2f}")
        return BRI
    else:
        print("Impossible de calculer le BRI. Vérifiez les images.")
        return None

# Exemple d'utilisation
user_height_cm = 163 # taille réelle de l'individu
image_path_side = r"C:\Users\elias\Downloads\photo_side_germine.jpg"
image_path_front = r"C:\Users\elias\Downloads\photo_front_germine.jpg"
calculer_bri(image_path_side, image_path_front, user_height_cm)
