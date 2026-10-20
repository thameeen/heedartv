
package tv.own.owntv.ui.components

import androidx.compose.material3.Text
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.text.font.FontWeight
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import org.koin.compose.koinInject
import tv.own.owntv.R
import tv.own.owntv.core.brand.AppIcon
import tv.own.owntv.core.brand.AppIconSwitcher
import tv.own.owntv.core.brand.PixelMark as CorePixelMark
import tv.own.owntv.core.settings.SettingsRepository
import tv.own.owntv.ui.theme.stageAccent

@Composable
fun rememberAppliedIcon(): AppIcon {
    val context = LocalContext.current
    return remember(context) { AppIconSwitcher.applied(context) }
}

@Composable
private fun accentTriangle(): Color? {
    val settings: SettingsRepository = koinInject()
    val on by settings.brandAccentTriangle.collectAsStateWithLifecycle(initialValue = true)
    return if (on) stageAccent.accent else null
}

@Composable
fun BrandMark(
    icon: AppIcon,
    size: Dp,
    modifier: Modifier = Modifier,
    followAccent: Boolean = true
) {
    val small = size <= 32.dp
    val accent = accentTriangle().takeIf { followAccent }

    if (icon == AppIcon.PIXEL && small) {
        PixelMark(modifier.size(size), triangle = accent ?: stageAccent.accent)
        return
    }

    Box(modifier.size(size)) {
        Image(
            painter = painterResource(
                if (small) R.drawable.owntv_mark_play_small
                else R.drawable.owntv_mark_play
            ),
            contentDescription = null,
            modifier = Modifier.fillMaxSize()
        )
    }
}

@Composable
fun PixelMark(
    modifier: Modifier = Modifier,
    triangle: Color = stageAccent.accent
) {
    Canvas(modifier) {
        val u = size.minDimension / 100f
        CorePixelMark.dots.forEach { d ->
            val color = when (d.kind) {
                CorePixelMark.Kind.BODY -> Color(CorePixelMark.BODY)
                CorePixelMark.Kind.TRIANGLE -> triangle
                CorePixelMark.Kind.SIDE -> Color(CorePixelMark.SIDE)
            }
            drawCircle(
                color,
                CorePixelMark.DOT_RADIUS * u,
                Offset(d.x * u, d.y * u)
            )
        }
        drawCircle(
            Color(CorePixelMark.POWER),
            CorePixelMark.POWER_RADIUS * u,
            Offset(CorePixelMark.POWER_X * u, CorePixelMark.POWER_Y * u)
        )
    }
}

private val PixelBody = Color(CorePixelMark.BODY)
private val PixelSide = Color(CorePixelMark.SIDE)
private val PixelPower = Color(CorePixelMark.POWER)

@Composable
fun Wordmark(
    width: Dp,
    modifier: Modifier = Modifier,
    tv: Color = stageAccent.accent,
    own: Color = WordmarkCream
) {
    Row(
        modifier = modifier.width(width),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            text = stringResource(R.string.brand_heedar),
            color = own,
            fontSize = (width.value * 0.12f).sp,
            fontWeight = FontWeight.Bold
        )
        Text(
            text = stringResource(R.string.brand_tv),
            color = tv,
            fontSize = (width.value * 0.12f).sp,
            fontWeight = FontWeight.Bold
        )
    }
}

val WordmarkCream = Color(0xFFFFF6EE)

@Composable
fun BrandLockup(
    modifier: Modifier = Modifier,
    markSize: Int = 36,
    stacked: Boolean = false
) {
    val icon = rememberAppliedIcon()
    val parts: @Composable () -> Unit = {
        BrandMark(icon, markSize.dp)
        Wordmark((markSize * 2.75f).dp)
    }

    if (stacked) {
        Column(
            modifier = modifier,
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy((markSize * 0.2f).dp)
        ) {
            parts()
        }
    } else {
        Row(
            modifier = modifier,
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy((markSize * 0.23f).dp)
        ) {
            parts()
        }
    }
}
